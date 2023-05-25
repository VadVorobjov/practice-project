//
//  LocalTaskLoader.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 25/05/2023.
//

final class LocalTaskLoader {
    typealias Result = Error?
    
    private let store: TaskStore
    
    init(store: TaskStore) {
        self.store = store
    }

    func save(_ item: Task, completion: @escaping (Result) -> Void) {
        store.insert(item) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }

    func delete(_ item: Task, completion: @escaping (Result) -> Void) {
        store.delete(item) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
}
