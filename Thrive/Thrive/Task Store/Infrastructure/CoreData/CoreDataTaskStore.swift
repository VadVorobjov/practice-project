//
//  CoreDataTaskStore.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 10/07/2023.
//

import CoreData

public final class CoreDataTaskStore: CommandStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        self.container = try NSPersistentContainer.load(modelName: "CommandStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func insert(_ item: LocalTask, completion: @escaping InsertionCompletion) {
        context.perform { [context] in
            completion(Result {
                ManagedCommand.manage(item, in: context)
                try context.save()
            })
        }
    }
    
    public func delete(_ item: LocalTask, completion: @escaping DeletionCompletion) {
        context.perform { [context] in
            completion(Result {
                let store = try ManagedCommand.find(item, in: context)
                
                if let store {
                    context.delete(store)
                    try context.save()
                }
            })
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        context.perform { [context] in
            completion(Result {
                let store = try ManagedCommand.find(in: context)
                
                guard !store.isEmpty else { return .none }
                
                return store.map { return $0.local }
            })
        }
    }
}
