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
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_load_deliversNoTasksOnEmptyStore() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeWithEmptyStore()
        }
    }
    
    func test_load_deliversTasksOnNoneEmptyStore() {
        let (sut, store) = makeSUT()
        let tasks = [uniqueTask(), uniqueTask()].toLocal()
        
        expect(sut, toCompleteWith: .success(tasks.toModel())) {
            store.completeRetrieval(with: tasks)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = TaskStoreSpy()
        var sut: LocalComamndLoader? = LocalComamndLoader(store: store)
        
        var receivedResults = [LocalComamndLoader.LoadResult]()
        sut?.load { receivedResults.append($0) }
        
        sut = nil
        
        store.completeRetrieval(with: someNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalComamndLoader, store: TaskStoreSpy) {
        let store = TaskStoreSpy()
        let sut = LocalComamndLoader(store: store)
        trackMemoryLeaks(store, file: file, line: line)
        trackMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    private func expect(_ sut: LocalComamndLoader,
                        toCompleteWith expectedResult: LocalComamndLoader.LoadResult,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for load to complete")
                
        sut.load { receivedResult  in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedTasks), .success(expectedTasks)):
                XCTAssertEqual(receivedTasks, expectedTasks, file: file, line: line)
                
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
}

private extension Array where Element == Command {
    func toLocal() -> [LocalTask] {
        return map {
            LocalTask(id: $0.id,
                      name: $0.name,
                      description: $0.description,
                      date: $0.date)
        }
    }
}
