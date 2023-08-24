//
//  StoreTaskUseCaseTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 21/05/2023.
//

import XCTest
@testable import Thrive

final class StoreTaskUseCaseTests: XCTestCase {
    
    func test_save_requestsInsertion() {
        let (sut, store) = makeSUT()
        let item = uniqueTask()
        
        sut.save(item) { _ in }
        
        XCTAssertEqual(store.receivedMessage, .insert(item.toLocal()))
    }
    
    func test_save_deliversErrorOnAFailedSave() {
        let (sut, store) = makeSUT()
        let saveError = someNSError()
        
        expect(sut, on: .save, completeWithError: saveError) {
            store.completeSave(with: saveError)
        }
    }
    
    func test_save_successfullyDoesNotDeliverError() {
        let (sut, store) = makeSUT()
        
        expect(sut, on: .save, completeWithError: nil) {
            store.completeSaveSuccessfully()
        }
    }
    
    func test_delete_requestsDeletion() {
        let (sut, store) = makeSUT()
        let item = uniqueTask()
        
        sut.delete(item) { _ in }
        
        XCTAssertEqual(store.receivedMessage, .delete(item.toLocal()))
    }
    
    func test_delete_deliversErrorOnAFailedDelete() {
        let (sut, store) = makeSUT()
        let deleteError = someNSError()
        
        expect(sut, on: .delete, completeWithError: deleteError) {
            store.completeDelete(with: deleteError)
        }
    }
    
    func test_delete_successfullyDoesNotDeliverError() {
        let (sut, store) = makeSUT()
                
        expect(sut, on: .delete, completeWithError: nil) {
            store.completeDeleteSuccessfully()
        }
    }
    
    func test_save_doesNotDeliverSaveResultAfterSUTInstanceHasBeenDeallocated() {
        let store = TaskStoreSpy()
        expectSUT(with: store, toDeliverNoResult: .save) {
            store.completeSave(with: someNSError())
        }
    }
    
    func test_save_doesNotDeliverDeleteResultAfterSUTInstanceHasBeenDeallocated() {
        let store = TaskStoreSpy()
        expectSUT(with: store, toDeliverNoResult: .delete) {
            store.completeDelete(with: someNSError())
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalCommandLoader, store: TaskStoreSpy) {
        let store = TaskStoreSpy()
        let sut = LocalCommandLoader(store: store)
        trackMemoryLeaks(store, file: file, line: line)
        trackMemoryLeaks(store, file: file, line: line)

        return (sut, store)
    }
    
    private enum Action {
        case save
        case delete
    }
    
    private func expect(_ sut: LocalCommandLoader,
                        on actionType: Action,
                        completeWithError expectedError: NSError?,
                        action: () -> Void,
                        file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        var receivedError: Error?
        
        switch actionType {
        case .save:
            sut.save(uniqueTask()) { result in
                if case let Result.failure(error) = result { receivedError = error }
                exp.fulfill()
            }
            
        case .delete:
            sut.delete(uniqueTask()) { result in
                if case let Result.failure(error) = result { receivedError = error }
                exp.fulfill()
            }
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError)
    }
    
    private func expectSUT(with store: TaskStoreSpy, toDeliverNoResult actionType: Action, when action: () -> Void) {
        var sut: LocalCommandLoader? = LocalCommandLoader(store: store)
        var receivedResults = [Result<Void, Error>]()
        
        switch actionType {
        case .save:
            sut?.save(uniqueTask()) { receivedResults.append($0) }
        case .delete:
            sut?.delete(uniqueTask()) { receivedResults.append($0) }
        }
                          
        sut = nil

        action()
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
}
