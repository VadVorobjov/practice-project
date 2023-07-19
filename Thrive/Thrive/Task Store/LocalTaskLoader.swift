//
//  LocalTaskLoader.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 25/05/2023.
//

public final class LocalTaskLoader {
    public typealias Result = Error?
    public typealias LoadResult = Swift.Result<[Task], Error>
    
    private let store: TaskStore
    
    public init(store: TaskStore) {
        self.store = store
    }

    public func save(_ item: Task, completion: @escaping (Result) -> Void) {
        store.insert(item.toLocal()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        return store.retrieve { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(.some(tasks)):
                completion(.success(tasks.toModel()))

            case .success:
                completion(.success([]))
            }
        }
    }

    public func delete(_ item: Task, completion: @escaping (Result) -> Void) {
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

extension Array where Element == LocalTask {
    public func toModel() -> [Task] {
        return map {
            Task(id: $0.id,
                 name: $0.name,
                 description: $0.description,
                 date: $0.date)
        }
    }
}
