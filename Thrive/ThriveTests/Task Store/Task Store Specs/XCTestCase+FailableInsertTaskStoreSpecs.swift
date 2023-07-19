//
//  XCTestCase+FailableInsertTaskStoreSpecs.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 07/07/2023.
//

import XCTest
import Thrive

extension FailableInsertTaskStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnIsertionError(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        let task = uniqueTask().toLocal()
        
        let insertionError = insert(task, to: sut)
        
        XCTAssertNotNil(insertionError, "Expected store insertion to fail with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: TaskStore, file: StaticString = #file, line: UInt = #line) {
        let task = uniqueTask().toLocal()

        insert(task, to: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
