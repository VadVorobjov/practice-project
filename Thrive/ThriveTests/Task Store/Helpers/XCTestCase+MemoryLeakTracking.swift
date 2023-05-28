//
//  XCTestCase+MemoryLeakTracking.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 23/05/2023.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
