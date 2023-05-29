//
//  TaskStore.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 25/05/2023.
//

public protocol TaskStore {
    typealias InsertionCompletion = (Error?) -> Void
    typealias DeletionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (Error?) -> Void

    func insert(_ item: LocalTask, completion: @escaping InsertionCompletion)
    func delete(_ item: LocalTask, completion: @escaping DeletionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}

public struct LocalTask: Equatable {
    let id: UUID
    let name: String
    let description: String?
    let date: Date
}
