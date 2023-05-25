//
//  CacheTaskUseCaseTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 21/05/2023.
//

import XCTest
@testable import Thrive

final class CacheTaskUseCaseTests: XCTestCase {
    
    func test_save_requestsInsertion() {
        let (sut, store) = makeSUT()
        
        sut.save(uniqueTask()) { _ in }
        
        XCTAssertEqual(store.insertions.count, 1)
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
        
        sut.delete(uniqueTask()) { _ in }
        
        XCTAssertEqual(store.deletions.count, 1)
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
    
    func test_save_doesNotDeliverSaveErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = TaskStoreSpy()
        expectSUT(with: store, toDeliverNoErrorOn: .save) {
            store.completeSave(with: someNSError())
        }
    }
    
    func test_save_doesNotDeliverDeleteErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = TaskStoreSpy()
        expectSUT(with: store, toDeliverNoErrorOn: .delete) {
            store.completeDelete(with: someNSError())
        }
    }
    
    // MARK: - Helpers
    
    class TaskStoreSpy: TaskStore {
        private var insertionCompletions = [InsertionCompletion]()
        private var deletionCompletions = [DeletionCompletion]()

        var insertions = [Task]()
        var deletions = [Task]()
            
        func insert(_ item: Task, completion: @escaping InsertionCompletion) {
            insertions.append(item)
            insertionCompletions.append(completion)
        }

        func completeSave(with error: NSError, at index: Int = 0) {
            insertionCompletions[index](error)
        }

        func completeSaveSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }
        
        func delete(_ item: Task, completion: @escaping DeletionCompletion) {
            deletions.append(item)
            deletionCompletions.append(completion)
        }
        
        func completeDelete(with error: NSError, at index: Int = 0) {
            deletionCompletions[index](error)
        }
        
        func completeDeleteSuccessfully(at index: Int = 0) {
            deletionCompletions[index](nil)
        }
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalTaskLoader, store: TaskStoreSpy) {
        let store = TaskStoreSpy()
        let sut = LocalTaskLoader(store: store)
        trackMemoryLeaks(store, file: file, line: line)
        trackMemoryLeaks(store, file: file, line: line)

        return (sut, store)
    }
    
    private enum Action {
        case save
        case delete
    }
    
    private func expect(_ sut: LocalTaskLoader,
                        on actionType: Action,
                        completeWithError expectedError: NSError?,
                        action: () -> Void,
                        file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        var receivedError: Error?
        
        switch actionType {
        case .save:
            sut.save(uniqueTask()) { error in
                receivedError = error
                exp.fulfill()
            }
            
        case .delete:
            sut.delete(uniqueTask()) { error in
                receivedError = error
                exp.fulfill()
            }
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError)
    }
    
    private func expectSUT(with store: TaskStoreSpy, toDeliverNoErrorOn actionType: Action, when action: () -> Void) {
        var sut: LocalTaskLoader? = LocalTaskLoader(store: store)
        var receivedResults = [LocalTaskLoader.Result]()
        
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
    
    private func uniqueTask() -> Task {
        return Task(id: UUID(),
                    name: "some name",
                    description: "some description",
                    date: Date.init())
    }    
}
