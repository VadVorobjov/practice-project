//
//  CoreDataTaskStoreTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 09/07/2023.
//

import XCTest
import Thrive

final class CoreDataTaskStoreTests: XCTestCase, TaskStoreSpecs {
    
    func test_retrieve_deliversEmptyOnEmptyStore() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyStore(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmtpyStore() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyStore(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyStore() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversFoundValuesOnNonEmptyStore(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyStore() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnNonEmptyStore(on: sut)
    }
    
    func test_insert_deliversNoErrorOnEmptyStore() {
        let sut = makeSUT()
        
        assertThatInsertDeliversNoErrorOnEmptyStore(on: sut)
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
        let storeBundle = Bundle(for: CoreDataTaskStore.self)
        let storeURL = URL(filePath: "/dev/null")
        let sut = try! CoreDataTaskStore(storeURL: storeURL, bundle: storeBundle)
        trackMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}