//
//  LocalComamndLoader.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 25/05/2023.
//

public protocol CommandSerialization: CommandLoader & CommandSave {}

public protocol CommandLoader {
    typealias LoadResult = Swift.Result<[Command], Error>
    
    func load(completion: @escaping (LoadResult) -> Void)
}

public protocol CommandSave {
    typealias SaveResult = Swift.Result<Void, Error>
    
    func save(_ item: Command, completion: @escaping (SaveResult) -> Void)
}

public final class LocalCommandLoader: CommandSerialization {
    private let store: CommandStore
    
    public init(store: CommandStore) {
        self.store = store
    }
}

extension LocalCommandLoader: CommandSave {
    public func save(_ item: Command, completion: @escaping (SaveResult) -> Void) {
        store.insert(item.toLocal()) { [weak self] saveResult in
            guard self != nil else { return }
            
            completion(saveResult)
        }
    }
}
    
extension LocalCommandLoader: CommandLoader {
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
}

extension LocalCommandLoader {
    public typealias DeleteResult = Result<Void, Error>

    public func delete(_ item: Command, completion: @escaping (DeleteResult) -> Void) {
        store.delete(item.toLocal()) { [weak self] deleteResult in
            guard self != nil else { return }
            
            completion(deleteResult)
        }
    }
}

private extension Command {
    func toLocal() -> LocalTask {
        return LocalTask(id: self.id,
                         name: self.name,
                         description: self.description,
                         date: self.date)
    }
}

extension Array where Element == LocalTask {
    public func toModel() -> [Command] {
        return map {
            Command(id: $0.id,
                 name: $0.name,
                 description: $0.description,
                 date: $0.date)
        }
    }
}
