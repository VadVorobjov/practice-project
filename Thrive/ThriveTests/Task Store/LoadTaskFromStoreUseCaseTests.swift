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
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessage, .retrieve)
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = someNSError()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedError: Error?
        sut.load { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            exp.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, retrievalError)
    }
    
    func test_load_deliversNoTasksOnEmptyStore() {
        let (sut, store) = makeSUT()
        let exp = expectation(description: "Wait for load to complete")

        var receivedTasks: [Task]?
        sut.load { result in
            switch result {
            case let .success(tasks):
                receivedTasks = tasks
            default:
                XCTFail("Expected success, got \(result) instead")
            }
            exp.fulfill()
        }

        store.completeWithEmptyStore()
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(receivedTasks, [])
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
