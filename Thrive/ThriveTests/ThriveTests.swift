//
//  ThriveTests.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 18/05/2023.
//

import XCTest
@testable import Thrive

struct Task {
    let id: UUID
       let name: String
       let description: String?
       let date: Date
}

final class ThriveTests: XCTestCase {

    func test_task_beingSavedToCache() {
        
    }

    
    // MARK: - Helpers
    
    private func task() -> Task {
        Task(id: UUID(), name: "some name", description: "some description", date: Date.init())
    }
}
