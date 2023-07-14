//
//  ThriveTaskStoreIntegrationTests.swift
//  ThriveTaskStoreIntegrationTests
//
//  Created by Vadims Vorobjovs on 13/07/2023.
//

import XCTest
import Thrive

final class ThriveTaskStoreIntegrationTests: XCTestCase {

    func test_load_deliversNoItemsOnEmptyStore() {
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(tasks):
                XCTAssertEqual(tasks, [], "Expected empty tasks")
            case let .failure(error):
                XCTFail("Expected successful tasks result, got \(error) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
 
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalTaskLoader {
        let storeBundle = Bundle(for: CoreDataTaskStore.self)
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataTaskStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalTaskLoader(store: store)
        
        trackMemoryLeaks(store, file: file, line: line)
        trackMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
