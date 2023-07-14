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
    
    func test_save_appendNewItemToPreviouslySavedItemOnASeparateInstance() {
        let sutToPerformFirstSave = makeSUT()
        let sutToPerformSecondSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let firstTask = uniqueTask()
        let secondTask = uniqueTask()
        
        save(firstTask, on: sutToPerformFirstSave)
        save(secondTask, on: sutToPerformSecondSave)
        
        expect(sutToPerformLoad, toLoad: [firstTask, secondTask])
    }
    
    // MARK: - Helpers
 
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalTaskLoader {
        let storeBundle = Bundle(for: CoreDataTaskStore.self)
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataTaskStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalTaskLoader(store: store)
        
        trackMemoryLeaks(store, file: file, line: line)
        trackMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func save(_ task: Task, on sut: LocalTaskLoader) {
        let exp = expectation(description: "Wait for save completion")
        
        sut.save(task) { saveError in
            XCTAssertNil(saveError, "Expected no error on save")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func delete(_ task: Task, on sut: LocalTaskLoader) {
        let exp = expectation(description: "Wait for deletion completion")
        
        sut.delete(task) { deletionError in
            XCTAssertNil(deletionError, "Expected no error on deletion")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: LocalTaskLoader, toLoad expectedTasks: [Task] ) {
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
