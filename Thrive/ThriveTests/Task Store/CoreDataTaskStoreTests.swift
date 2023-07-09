//
//  CoreDataTaskStoreTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 09/07/2023.
//

import XCTest
import Thrive

final class CoreDataTaskStore: TaskStore {
    
    func insert(_ item: Thrive.LocalTask, completion: @escaping InsertionCompletion) {
        
    }
    
    func delete(_ item: Thrive.LocalTask, completion: @escaping DeletionCompletion) {
        
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        return completion(.empty)
    }
}

final class CoreDataTaskStoreTests: XCTestCase, TaskStoreSpecs {
    
    func test_retrieve_deliversEmptyOnEmptyStore() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyStore(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmtpyStore() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyStore(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNoneEmptyStore() {
        
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyStore() {
        
    }
    
    func test_insert_deliversNoErrorOnEmptyStore() {
        
    }
    
    func test_insert_applyValueToPrevioslyInsertedValues() {
        
    }
    
    func test_delete_hasNoSideEffectsOnEmptyStore() {
        
    }
    
    func test_delete_onNonEmptyStoreDeletesProvidedTask() {
        
    }
    
    func test_storeSideEffects_runSerially() {
        
    }
    
    // MARK: - Heleprs
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TaskStore {
        let sut = CoreDataTaskStore()
        trackMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
