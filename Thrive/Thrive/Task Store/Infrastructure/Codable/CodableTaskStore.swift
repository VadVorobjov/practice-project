//
//  CodableTaskStore.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 04/07/2023.
//

public class CodableTaskStore: TaskStore {
    private struct Store: Codable {
        let tasks: [CodableTask]
        
        var localTasks: [LocalTask] {
            return tasks.map { $0.local }
        }
    }
    
    private struct CodableTask: Codable {
        private let id: UUID
        private let name: String
        private let description: String?
        private let date: Date
        
        init(_ task: LocalTask) {
            id = task.id
            name = task.name
            description = task.description
            date = task.date
        }
        
        var local: LocalTask {
            return LocalTask(id: id, name: name, description: description, date: date)
        }
    }
    
    private let queue = DispatchQueue(label: "\(CodableTaskStore.self)Queue", qos: .userInitiated)
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func delete(_ item: LocalTask, completion: @escaping DeletionCompletion) {
        queue.async { [unowned self] in
            retrieve { result in
                switch result {
                case var .found(items: items):
                    items.removeAll { $0.id == item.id }
                    
                    guard !items.isEmpty else {
                        return self.removeItem(at: self.storeURL, completion: completion)
                    }
                    
                    self.write(items: items, completion: completion)
                    
                case .empty:
                    completion(nil)
                    
                case let .failure(error):
                    completion(error)
                }
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        queue.async { [storeURL] in
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.empty)
            }
            
            do {
                let decoder = JSONDecoder()
                let store = try decoder.decode(Store.self, from: data)
                
                guard store.tasks.count > 0 else {
                    return completion(.empty)
                }
                
                completion(.found(items: store.tasks.map { $0.local }))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ item: LocalTask, completion: @escaping InsertionCompletion) {
        queue.async { [unowned self] in
            self.retrieve { result in
                switch result {
                case var .found(items: items):
                    items.append(item)
                    self.write(items: items, completion: completion)
                    
                case .empty:
                    self.write(items: [item], completion: completion)
                    
                case let .failure(error):
                    completion(error)
                }
            }
        }
    }
    
    private func write(items: [LocalTask], completion: @escaping TaskStore.InsertionCompletion) {
        do {
            let encoder = JSONEncoder()
            let store = Store(tasks: items.map(CodableTask.init))
            let encoded = try encoder.encode(store)
            try encoded.write(to: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    private func removeItem(at url: URL, completion: @escaping TaskStore.DeletionCompletion)  {
        do {
            try FileManager.default.removeItem(at: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
