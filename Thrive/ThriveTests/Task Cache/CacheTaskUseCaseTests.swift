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

    func save(_ item: Task) {
        store.insert(item) { _ in }
    }
}

class TaskStore {
    typealias InsertionCompletion = (Error?) -> Void
    typealias DeletionCompletion = (Error?) -> Void

    private var insertionCompletions = [InsertionCompletion]()
    private var deletionCompletions = [DeletionCompletion]()

    var insertions = [Task]()
    var deleteStoreCallCount = 0
        
    func insert(_ item: Task, completion: @escaping InsertionCompletion) {
        insertions.append(item)
        insertionCompletions.append(completion)
    }
}

final class CacheTaskUseCaseTests: XCTestCase {
    func test_save_requestsInsertion() {
        let (sut, store) = makeSUT()
        
        sut.save(uniqueTask()) { _ in }
        
        XCTAssertEqual(store.insertions.count, 1)
    }
    
    func test_save_doesNotDeleteStore() {
        let (sut, store) = makeSUT()

        sut.save(uniqueTask())

        XCTAssertEqual(store.deleteStoreCallCount, 0)
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
