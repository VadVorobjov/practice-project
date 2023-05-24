//
//  CacheTaskUseCaseTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 21/05/2023.
//

import XCTest
@testable import Thrive

class LocalTaskLoader {
    private let store: TaskStore
    
    init(store: TaskStore) {
        self.store = store
    }

    func save(_ item: Task, completion: @escaping (Error?) -> Void) {
        store.insert(item) { error in
            completion(error)
        }
    }

    func delete(_ item: Task, completion: @escaping (Error?) -> Void) {
        store.delete(item) { error in
            completion(error)
        }
    }
    
}

class TaskStore {
    typealias InsertionCompletion = (Error?) -> Void
    typealias DeletionCompletion = (Error?) -> Void

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

final class CacheTaskUseCaseTests: XCTestCase {
    
    func test_save_requestsInsertion() {
        let (sut, store) = makeSUT()
        
        sut.save(uniqueTask()) { _ in }
        
        XCTAssertEqual(store.insertions.count, 1)
    }
    
    func test_save_deliversErrorOnAFailedSave() {
        let (sut, store) = makeSUT()
        let saveError = someNSError()

        var receivedError: Error?
        sut.save(uniqueTask()) { error in
            receivedError = error
        }
        store.completeSave(with: saveError)

        XCTAssertEqual(saveError, receivedError as NSError?)
    }

    func test_save_successfullyDoesNotDeliverError() {
        let (sut, store) = makeSUT()
        
        var receivedError: Error?
        sut.save(uniqueTask()) { error in
            receivedError = error
        }
        store.completeSaveSuccessfully()

        XCTAssertNil(receivedError)
    }
    
    func test_delete_requestsDeletion() {
        let (sut, store) = makeSUT()
        
        sut.delete(uniqueTask()) { _ in }
        
        XCTAssertEqual(store.deletions.count, 1)
    }
    
    func test_delete_deliversErrorOnAFailedDelete() {
        let (sut, store) = makeSUT()
        let deleteError = someNSError()
        
        var receivedError: Error?
        sut.delete(uniqueTask()) { error in
            receivedError = error
        }
        store.completeDelete(with: deleteError)
        
        XCTAssertEqual(deleteError, receivedError as NSError?)
    }
    
    func test_delete_successfullyDoesNotDeliverError() {
        let (sut, store) = makeSUT()
        
        var receivedError: Error?
        sut.delete(uniqueTask()) { error in
            receivedError = error
        }
        store.completeDeleteSuccessfully()
        
        XCTAssertNil(receivedError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalTaskLoader, store: TaskStore) {
        let store = TaskStore()
        let sut = LocalTaskLoader(store: store)
        trackMemoryLeaks(store, file: file, line: line)
        trackMemoryLeaks(store, file: file, line: line)

        return (sut, store)
    }
    
    private func uniqueTask() -> Task {
        return Task(id: UUID(),
                    name: "some name",
                    description: "some description",
                    date: Date.init())
    }    
}
