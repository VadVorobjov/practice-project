//
//  CacheTaskUseCaseTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 21/05/2023.
//

import XCTest

class LocalTaskLoader {
    init(store: TaskStore) {
        
    }
}

class TaskStore {
    var deleteCachedTaskCallCount = 0
}

final class CacheTaskUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let store = TaskStore()
        _ = LocalTaskLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedTaskCallCount, 0)
    }
}
