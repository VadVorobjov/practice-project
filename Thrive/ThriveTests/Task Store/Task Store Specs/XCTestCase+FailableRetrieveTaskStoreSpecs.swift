//
//  XCTestCase+FailableRetrieveTaskStoreSpecs.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 07/07/2023.
//

import XCTest
import Thrive

extension FailableRetrieveTaskStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: CommandStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .failure(someNSError()), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: CommandStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .failure(someNSError()))
    }
}
