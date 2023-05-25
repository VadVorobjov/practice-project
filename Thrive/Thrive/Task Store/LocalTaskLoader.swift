//
//  LocalTaskLoader.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 25/05/2023.
//

final class LocalTaskLoader {
    private let store: TaskStore
    
    init(store: TaskStore) {
        self.store = store
    }

    func save(_ item: Task, completion: @escaping (Error?) -> Void) {
        store.insert(item) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }

    func delete(_ item: Task, completion: @escaping (Error?) -> Void) {
        store.delete(item) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
}
