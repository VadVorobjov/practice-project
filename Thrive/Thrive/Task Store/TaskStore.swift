//
//  TaskStore.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 25/05/2023.
//

public protocol TaskStore {
    typealias InsertionCompletion = (Error?) -> Void
    typealias DeletionCompletion = (Error?) -> Void

    func insert(_ item: LocalTask, completion: @escaping InsertionCompletion)
    func delete(_ item: LocalTask, completion: @escaping DeletionCompletion)
}

public struct LocalTask {
    let id: UUID
    let name: String
    let description: String?
    let date: Date
}
