//
//  TaskStore.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 25/05/2023.
//

public enum RetrieveStoredTaskResult {
    case empty
    case found(tasks: [LocalTask])
    case failure(Error)
}

public protocol TaskStore {
    typealias InsertionCompletion = (Error?) -> Void
    typealias DeletionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveStoredTaskResult) -> Void

    func insert(_ item: LocalTask, completion: @escaping InsertionCompletion)
    func delete(_ item: LocalTask, completion: @escaping DeletionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}

public struct LocalTask: Equatable {
    public let id: UUID
    public let name: String
    public let description: String?
    public let date: Date
    
    public init(id: UUID, name: String, description: String? = nil, date: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.date = date
    }
}
