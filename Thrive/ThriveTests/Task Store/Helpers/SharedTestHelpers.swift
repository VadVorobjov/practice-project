//
//  SharedTestHelpers.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 23/05/2023.
//

import Foundation
import Thrive

func someNSError() -> NSError {
    return NSError(domain: "some error", code: 0)
}

func someURL() -> URL {
    return URL(string: "http://some-url.com")!
}

func uniqueTask() -> Task {
    return Task(id: UUID(),
                name: "some name",
                description: "some description",
                date: Date.init())
}

extension Task {
    func toLocal() -> LocalTask {
        LocalTask(id: self.id,
                  name: self.name,
                  description: self.description,
                  date: self.date)
    }
}
