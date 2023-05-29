//
//  LocalTaskLoader.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 25/05/2023.
//

public final class LocalTaskLoader {
    public typealias Result = Error?
    
    private let store: TaskStore
    
    public init(store: TaskStore) {
        self.store = store
    }

    func save(_ item: Task, completion: @escaping (Result) -> Void) {
        store.insert(item.toLocal()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        store.retrieve(completion: completion)
    }

    func delete(_ item: Task, completion: @escaping (Result) -> Void) {
        store.delete(item.toLocal()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

private extension Task {
    func toLocal() -> LocalTask {
        return LocalTask(id: self.id,
                         name: self.name,
                         description: self.description,
                         date: self.date)
    }
}
