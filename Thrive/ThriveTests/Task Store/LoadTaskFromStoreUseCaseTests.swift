//
//  LoadTaskFromStoreUseCaseTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 28/05/2023.
//

import XCTest
import Thrive

final class LoadTaskFromStoreUseCaseTests: XCTestCase {
    
    func test_load_requestsStoreRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load()
        
        XCTAssertEqual(store.receivedMessage, .retrieve)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalTaskLoader, store: TaskStoreSpy) {
        let store = TaskStoreSpy()
        let sut = LocalTaskLoader(store: store)
        trackMemoryLeaks(store, file: file, line: line)
        trackMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    
}
