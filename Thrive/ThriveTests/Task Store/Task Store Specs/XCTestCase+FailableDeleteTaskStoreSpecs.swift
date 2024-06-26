//
//  XCTestCase+FailableDeleteTaskStoreSpecs.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 07/07/2023.
//

import XCTest
import Thrive

extension FailableDeleteTaskStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnFailure(on sut: CommandStore, file: StaticString = #file, line: UInt = #line) {
        let task = uniqueTask().toLocal()

        let deletionError = delete(task, from: sut)
        
        XCTAssertNotNil(deletionError, "Expected deletion to deliver an error", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: CommandStore, file: StaticString = #file, line: UInt = #line) {
        let task = uniqueTask().toLocal()
        
        delete(task, from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
