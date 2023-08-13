//
//  CommandStore.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 25/05/2023.
//

//public enum StoredTasks {
//    case empty
//    case found(items: [LocalTask])
//}

public protocol CommandStore {
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void

    typealias RetrievalResult = Result<[LocalTask]?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate thread, if needed.
    func insert(_ item: LocalTask, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate thread, if needed.
    func delete(_ item: LocalTask, completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate thread, if needed.
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
