//
//  ThriveTaskStoreIntegrationTests.swift
//  ThriveTaskStoreIntegrationTests
//
//  Created by Vadims Vorobjovs on 13/07/2023.
//

import XCTest
import Thrive

final class ThriveTaskStoreIntegrationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_load_deliversNoItemsOnEmptyStore() {
        let sut = makeSUT()
              
        expect(sut, toLoad: [])        
    }
    
    func test_load_deliversItemsSavedOnASeparateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let task = uniqueTask()
        
        save(task, on: sutToPerformSave)
        
        expect(sutToPerformLoad, toLoad: [task])
    }
    
    func test_save_appendsNewItemToPreviouslySavedItemOnASeparateInstance() {
        let sutToPerformFirstSave = makeSUT()
        let sutToPerformSecondSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let firstTask = uniqueTask()
        let secondTask = uniqueTask()
        
        save(firstTask, on: sutToPerformFirstSave)
        save(secondTask, on: sutToPerformSecondSave)
        
        expect(sutToPerformLoad, toLoad: [firstTask, secondTask])
    }
    
    func test_delete_removesItemFromPreviouslySavedItemsOnASeparateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformDelete = makeSUT()
        let sutToPerformLoad = makeSUT()
        let task = uniqueTask()
        
        save(task, on: sutToPerformSave)
        
        delete(task, on: sutToPerformDelete)
                   
        expect(sutToPerformLoad, toLoad: [])
    }
    
    // MARK: - Helpers
 
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalCommandLoader {
        let storeBundle = Bundle(for: CoreDataTaskStore.self)
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataTaskStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalCommandLoader(store: store)
        
        trackMemoryLeaks(store, file: file, line: line)
        trackMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func save(_ task: Command, on sut: LocalCommandLoader) {
        let exp = expectation(description: "Wait for save completion")
        
        sut.save(task) { result in
            if case let Result.failure(error) = result {
                XCTAssertNil(error, "Expected no error on save")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func delete(_ task: Command, on sut: LocalCommandLoader) {
        let exp = expectation(description: "Wait for deletion completion")
        
        sut.delete(task) { result in
            if case let Result.failure(error) = result {
                XCTAssertNil(error, "Expected no error on deletion")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: LocalCommandLoader, toLoad expectedTasks: [Command] ) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { result in
            switch result {
            case let .success(tasks):
                XCTAssertEqual(tasks, expectedTasks, "Expected empty tasks")
            
            case let .failure(error):
                XCTFail("Expected successful tasks result, got \(error) instead")
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
}
