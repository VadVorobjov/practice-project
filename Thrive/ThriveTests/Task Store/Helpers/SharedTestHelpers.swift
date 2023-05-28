//
//  SharedTestHelpers.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 23/05/2023.
//

import Foundation

func someNSError() -> NSError {
    return NSError(domain: "some error", code: 0)
}

private func someURL() -> URL {
    return URL(string: "http://some-url.com")!
}
