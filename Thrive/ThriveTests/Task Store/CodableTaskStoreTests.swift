//
//  CodableTaskStoreTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 19/06/2023.
//

import XCTest
import Thrive

class CodableTaskStore {
    func retrieve(completion: @escaping TaskStore.RetrievalCompletion) {
        completion(.empty)
    }
}

final class CodableTaskStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyStore() {
        let sut = CodableTaskStore()
        let exp = expectation(description: "Wait for retreival completion")
        
        sut.retrieve { result in
            switch result {
            case .empty:
                break
                
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmtpyStore() {
        let sut = CodableTaskStore()
        let exp = expectation(description: "Wait for retreival completion")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                    
                default:
                    XCTFail("Expected retrieving twice from empty store to deliver same result, got \(firstResult) and \(secondResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
