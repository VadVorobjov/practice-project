//
//  LocalCommandLoader.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 25/05/2023.
//

public final class LocalCommandLoader: CommandSerialization {
  private let store: CommandStore
  
  public init(store: CommandStore) {
    self.store = store
  }
  
  public func save(_ item: Command, completion: @escaping (SaveResult) -> Void) {
    store.insert(item.toLocal()) { [weak self] saveResult in
      guard self != nil else { return }
      
      completion(saveResult)
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
