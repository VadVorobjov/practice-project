//
//  CoreDataTaskStore.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 10/07/2023.
//

import CoreData

public final class CoreDataTaskStore: TaskStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        self.container = try NSPersistentContainer.load(modelName: "TaskStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func insert(_ item: LocalTask, completion: @escaping InsertionCompletion) {
        context.perform { [context] in
            do {
                ManagedTask.manage(item, in: context)

                try context.save()
                
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func delete(_ item: LocalTask, completion: @escaping DeletionCompletion) {
        context.perform { [context] in
            do {
                let store = try ManagedTask.find(item, in: context)
                
                if let store = store {
                    context.delete(store)
                    try context.save()
                }
                
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        context.perform { [context] in
            do {
                let store = try ManagedTask.find(in: context)
                
                guard !store.isEmpty else {
                    return completion(.success(.none))
                }
                
                completion(.success(store.map { $0.local }))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
