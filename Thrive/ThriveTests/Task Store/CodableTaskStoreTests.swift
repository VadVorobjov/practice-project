//
//  CodableTaskStoreTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 19/06/2023.
//

import XCTest
import Thrive

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
    
    func test_insert_deliversNoErrorOnEmptyStore() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        let task = uniqueTask().toLocal()
        
        let insertionError = insert(task, to: sut)
                
        XCTAssertNil(insertionError, "Expected no error on insertion")
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
        let storeURL = invalidStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        let task = uniqueTask().toLocal()
        
        let insertionError = insert(task, to: sut)
        
        XCTAssertNotNil(insertionError, "Expected store insertion to fail with an error")
    }
    
    func test_insert_hasNoSideEffectsOnInsertionError() {
        let storeURL = invalidStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        let task = uniqueTask().toLocal()

        insert(task, to: sut)
        
        expect(sut, toRetrieve: .empty)
    }
        
    func test_delete_hasNoSideEffectsOnEmptyStore() {
        let sut = makeSUT()
        let task = uniqueTask().toLocal()
        
        let deletionError = delete(task, from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_onNonEmptyStoreDeletesProvidedTask() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        let firstTask = uniqueTask().toLocal()
        let secondTask = uniqueTask().toLocal()
        
        insert(firstTask, to: sut)
        insert(secondTask, to: sut)
        
        delete(firstTask, from: sut)
        
        expect(sut, toRetrieve: .found(items: [secondTask]))
    }
    
    func test_delete_removesStoreFile_afterDeletingLastStoredTask() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        let task = uniqueTask().toLocal()
        
        insert(task, to: sut)
        delete(task, from: sut)
        
        let fileExists = FileManager.default.fileExists(atPath: storeURL.path())
        
        XCTAssertFalse(fileExists, "Expected to remove store file after deleting last stored task")
    }

    func test_delete_deliversErrorOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        let task = uniqueTask().toLocal()
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        let deletionError = delete(task, from: sut)
        
        XCTAssertNotNil(deletionError, "Expected deletion to deliver an error")
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        let task = uniqueTask().toLocal()
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(task) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.delete(task) { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueTask().toLocal()) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially, but operations finished in the wrong order")
    }
    
    // - MARK: Helpers
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> TaskStore {
        let sut = CodableTaskStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: TaskStore, toRetrieve expectedResult: RetrieveStoredTaskResult, file: StaticString = #file, line: UInt = #line) {
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
    
    private func expect(_ sut: TaskStore, toRetrieveTwice expectedResult: RetrieveStoredTaskResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult)
        expect(sut, toRetrieve: expectedResult)
    }
    
    @discardableResult
    private func insert(_ task: LocalTask, to sut: TaskStore) -> Error? {
        let exp = expectation(description: "Wait for store insertion")
        var insertionError: Error?
        
        sut.insert(task) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return insertionError
    }
    
    @discardableResult
    private func delete(_ task: LocalTask, from sut: TaskStore) -> Error? {
        let exp = expectation(description: "Wait for delete to complete")
        var deletionError: Error?
        
        sut.delete(task) { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return deletionError
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask)
        .first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func invalidStoreURL() -> URL {
        return URL(string: "invalid://store-url")!
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
