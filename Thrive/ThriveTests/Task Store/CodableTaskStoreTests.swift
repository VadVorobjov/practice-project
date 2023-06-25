//
//  CodableTaskStoreTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 19/06/2023.
//

import XCTest
import Thrive

class CodableTaskStore {
    private struct Store: Codable {
        let tasks: [CodableTask]
        
        var localTasks: [LocalTask] {
            return tasks.map { $0.local}
        }
    }
    
    private struct CodableTask: Codable {
        private let id: UUID
        private let name: String
        private let description: String?
        private let date: Date
        
        init(_ task: LocalTask) {
            id = task.id
            name = task.name
            description = task.description
            date = task.date
        }
        
        var local: LocalTask {
            return LocalTask(id: id, name: name, description: description, date: date)
        }
    }
    
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(completion: @escaping TaskStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        let decoder = JSONDecoder()
        do {
            let store = try decoder.decode(Store.self, from: data)
            completion(.found(items: store.tasks.map { $0.local }))
        } catch {
            completion(.failure(error))
        }
    }
    
    func insert(_ item: LocalTask, completion: @escaping TaskStore.InsertionCompletion) {
        retrieve { [weak self] result in
            switch result {
            case var .found(items: items):
                items.append(item)
                self?.write(items: items, completion: completion)
                
            case .empty:
                self?.write(items: [item], completion: completion)
                
            case let .failure(error):
                completion(error)
            }
        }
    }
    
    private func write(items: [LocalTask], completion: @escaping TaskStore.InsertionCompletion) {
        do {
            let encoder = JSONEncoder()
            let store = Store(tasks: items.map(CodableTask.init))
            let encoded = try encoder.encode(store)
            try encoded.write(to: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}

final class CodableTaskStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_retrieve_deliversEmptyOnEmptyStore() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmtpyStore() {
        let sut = makeSUT()

        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNoneEmptyStore() {
        let sut = makeSUT()
        let task = uniqueTask().toLocal()
        
        insert(task, to: sut)
        
        expect(sut, toRetrieve: .found(items: [task]))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let task = uniqueTask().toLocal()
        
        insert(task, to: sut)
        
        expect(sut, toRetrieveTwice: .found(items: [task]))
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieve: .failure(someNSError()))
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(someNSError()))
    }
    
    func test_insert_appliesToPrevioslyInsertedValues() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        let firstTask = uniqueTask().toLocal()
        
        let firstError = insert(firstTask, to: sut)
        XCTAssertNil(firstError, "Expected to insert successfully")

        expect(sut, toRetrieve: .found(items: [firstTask]))

        let secondTask = uniqueTask().toLocal()
        
        let secondError = insert(secondTask, to: sut)
        XCTAssertNil(secondError, "Expected to apply successfully")
        
        expect(sut, toRetrieve: .found(items: [firstTask, secondTask]))
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")
        let sut = makeSUT(storeURL: invalidStoreURL)
        let task = uniqueTask().toLocal()
        
        let insertionError = insert(task, to: sut)
        
        XCTAssertNotNil(insertionError, "Expected store insertion to fail with an error")
    }
    
    // - MARK: Helpers
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> CodableTaskStore {
        let sut = CodableTaskStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: CodableTaskStore, toRetrieve expectedResult: RetrieveStoredTaskResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for store retreival")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty), (.failure, .failure):
                break
                
            case let (.found(expected), .found(retrieved)):
                XCTAssertEqual(retrieved, expected, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: CodableTaskStore, toRetrieveTwice expectedResult: RetrieveStoredTaskResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult)
        expect(sut, toRetrieve: expectedResult)
    }
    
    @discardableResult
    private func insert(_ task: LocalTask, to sut: CodableTaskStore) -> Error? {
        let exp = expectation(description: "Wait for store insertion")
        var insertionError: Error?
        
        sut.insert(task) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return insertionError
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask)
        .first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
}
