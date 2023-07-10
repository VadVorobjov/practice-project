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
    
    public init(bundle: Bundle = .main) throws {
        self.container = try NSPersistentContainer.load(modelName: "TaskStore", in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func insert(_ item: Thrive.LocalTask, completion: @escaping InsertionCompletion) {
        
    }
    
    public func delete(_ item: Thrive.LocalTask, completion: @escaping DeletionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        return completion(.empty)
    }
}

private class ManagedTask: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var taskDescription: String?
    @NSManaged var date:  Date
}

private extension NSPersistentContainer {
    enum LoadingError: Error {
        case modelNotFound
        case failedToLoadPersistentStores(Error)
    }
    
    static func load(modelName name: String, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        var loadError: Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistentStores($0) }
        
        return container
    }
}

private extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
