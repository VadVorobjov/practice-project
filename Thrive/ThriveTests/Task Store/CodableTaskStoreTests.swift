//
//  CodableTaskStoreTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 19/06/2023.
//

import XCTest
import Thrive

final class CodableTaskStoreTests: XCTestCase, FailableTaskStoreSpecs {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    // MARK: - Retrieve
    
    func test_retrieve_deliversEmptyOnEmptyStore() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyStore(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmtpyStore() {
        let sut = makeSUT()

        assertThatRetrieveHasNoSideEffectsOnEmptyStore(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNoneEmptyStore() {
        let sut = makeSUT()

        assertThatRetrieveDeliversFoundValuesOnNonEmptyStore(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnNonEmptyStore(on: sut)
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
                
        assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        assertThatRetrieveHasNoSideEffectsOnfailure(on: sut)
    }
    
    // MARK: - Insert
    
    func test_insert_deliversNoErrorOnEmptyStore() {
        let sut = makeSUT()
       
        assertThatInsertDeliversNoErrorOnEmptyStore(on: sut)
    }
    
    func test_insert_appliesToPrevioslyInsertedValues() {
        let sut = makeSUT()
        
        assertThatInsertAppliesToPreviouslyInsertedValues(on: sut)
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
    
    // MARK: - Delete
        
    func test_delete_hasNoSideEffectsOnEmptyStore() {
        let sut = makeSUT()
        
        assertThatDeleteHasNoSideEffectsOnEmptyStore(on: sut)
    }
    
    func test_delete_onNonEmptyStoreDeletesProvidedTask() {
        let sut = makeSUT()
        
        assertThatDeleteOnNonEmptyStoreDeletesProvidedTask(on: sut)
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
    
    func test_delete_hasNoSideEffectsOnDeletionError() {
        let validStoreURL = testSpecificStoreURL()
        var sut = makeSUT(storeURL: validStoreURL)
        let task = uniqueTask().toLocal()
        
        insert(task, to: sut)
        
        let invalidStoreURL = invalidStoreURL()
        sut = makeSUT(storeURL: invalidStoreURL)

        delete(task, from: sut)
            
        sut = makeSUT(storeURL: validStoreURL)
        expect(sut, toRetrieve: .found(items: [task]))
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()

        assertThatStoreSideEffectsRunResially(on: sut)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> TaskStore {
        let sut = CodableTaskStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackMemoryLeaks(sut, file: file, line: line)
        return sut
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
