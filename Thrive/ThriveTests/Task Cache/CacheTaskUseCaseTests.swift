//
//  CacheTaskUseCaseTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 21/05/2023.
//

import XCTest
@testable import Thrive

class LocalTaskLoader {
    init(store: TaskStore) {
        
    }
    
    func save(_ item: Task) {
        
    }
}

class TaskStore {
    var deleteCachedTaskCallCount = 0
}

final class CacheTaskUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deleteCachedTaskCallCount, 0)
    }
    
    func test_save_doesNotDeleteCache() {
        let (sut, store) = makeSUT()
        sut.save(uniqueTask())
        
        XCTAssertEqual(store.deleteCachedTaskCallCount, 0)
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
    
    private func someURL() -> URL {
        return URL(string: "http://some-url.com")!
    }
}
