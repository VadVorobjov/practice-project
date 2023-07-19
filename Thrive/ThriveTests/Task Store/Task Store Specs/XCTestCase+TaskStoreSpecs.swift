//
//  XCTestCase+TaskStoreSpecs.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 07/07/2023.
//

import XCTest
import Thrive

extension TaskStoreSpecs where Self: XCTestCase {
    
    // MARK: - Retrieve
    
    func assertThatRetrieveDeliversEmptyOnEmptyStore(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyStore(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyStore(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        let task = uniqueTask().toLocal()
        
        insert(task, to: sut)
        
        expect(sut, toRetrieve: .success([task]), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyStore(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        let task = uniqueTask().toLocal()
        
        insert(task, to: sut)
        
        expect(sut, toRetrieveTwice: .success([task]), file: file, line: line)
    }
    
    // MARK: - Insert
    
    func assertThatInsertDeliversNoErrorOnEmptyStore(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        let task = uniqueTask().toLocal()
        
        let insertionError = insert(task, to: sut)
                
        XCTAssertNil(insertionError, "Expected no error on insertion", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnEmptyStore(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        let task = uniqueTask().toLocal()
        
        insert(task, to: sut)
        
        expect(sut, toRetrieve: .success([task]))
    }
    
    func assertThatInsertApplyToPreviouslyInsertedValues(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        let firstTask = uniqueTask().toLocal()
        let secondTask = uniqueTask().toLocal()
        
        insert(firstTask, to: sut)
        insert(secondTask, to: sut)
        
        expect(sut, toRetrieve: .success([firstTask, secondTask]), file: file, line: line)
    }
    
    // MARK: - Delete
    
    func assertThatDeleteHasNoSideEffectsOnEmptyStore(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        let task = uniqueTask().toLocal()
        
        delete(task, from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }

    func assertThatDeleteOnNonEmptyStoreDeletesProvidedTask(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        let firstTask = uniqueTask().toLocal()
        let secondTask = uniqueTask().toLocal()
        
        insert(firstTask, to: sut)
        insert(secondTask, to: sut)
        
        delete(firstTask, from: sut)
        
        expect(sut, toRetrieve: .success([secondTask]), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnEmptyStore(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        let task = uniqueTask().toLocal()
        
        let deletionError = delete(task, from: sut)
        
        XCTAssertNil(deletionError, "Expected no error on deletion")
    }
     
    func assertThatStoreSideEffectsRunResially(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
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
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially, but operations finished in the wrong order", file: file, line: line)
    }
    
    // MARK: - Helpers
    
    func expect(_ sut: TaskStore, toRetrieveTwice expectedResult: TaskStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult)
        expect(sut, toRetrieve: expectedResult)
    }
    
    func expect(_ sut: TaskStore, toRetrieve expectedResult: TaskStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for store retreival")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.success(.none), .success(.none)), (.failure, .failure):
                break
                
            case let (.success(.some(expected)), .success(.some(retrieved))):
                XCTAssertEqual(retrieved, expected, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    @discardableResult
    func insert(_ task: LocalTask, to sut: TaskStore) -> Error? {
        let exp = expectation(description: "Wait for store insertion")
        var insertionError: Error?
        
        sut.insert(task) { result in
            if case let Result.failure(error) = result { insertionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return insertionError
    }
    
    @discardableResult
    func delete(_ task: LocalTask, from sut: TaskStore) -> Error? {
        let exp = expectation(description: "Wait for delete to complete")
        var deletionError: Error?
        
        sut.delete(task) { result in
            if case let Result.failure(error) = result { deletionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return deletionError
    }
}
