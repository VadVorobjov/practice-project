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
        let store = try! decoder.decode(Store.self, from: data)
        completion(.found(tasks: store.tasks.map { $0.local }))
    }
    
    func insert(_ item: LocalTask, completion: @escaping TaskStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let store = Store(tasks: [item].map(CodableTask.init))
        let encoded = try! encoder.encode(store)
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}

final class CodableTaskStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        try? FileManager.default.removeItem(at: storeURL())
    }
    
    override func tearDown() {
        super.tearDown()
        
        try? FileManager.default.removeItem(at: storeURL())
    }
    
    func test_retrieve_deliversEmptyOnEmptyStore() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for retreival completion")
        
        sut.retrieve { result in
            switch result {
            case .empty:
                break
                 
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmtpyStore() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for retreival completion")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                    
                default:
                    XCTFail("Expected retrieving twice from empty store to deliver same result, got \(firstResult) and \(secondResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieveAfterInsertingToEmptyStore_deliversInsertedValue() {
        let sut = makeSUT()
        let task = uniqueTask().toLocal()
        let exp = expectation(description: "Wait for store retrieval")
        
        sut.insert(task) { insertionError  in
            XCTAssertNil(insertionError, "Expected task to be inserted successfully")
            
            sut.retrieve { retrievedResult in
                switch retrievedResult {
                case let .found(retrievedTasks):
                    XCTAssertTrue(retrievedTasks.contains(task))
                    XCTAssertEqual(retrievedTasks.count, 1)
                default:
                    XCTFail("Expected result to contain \(task), got \(retrievedResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableTaskStore {
        let sut = CodableTaskStore(storeURL: storeURL())
        trackMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func storeURL() -> URL {
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        .first!.appendingPathComponent("tasks.store")
    }
}
