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
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        context.perform { [context] in
            do {
                let request = NSFetchRequest<ManagedTask>(entityName: ManagedTask.entity().name!)
                request.returnsObjectsAsFaults = false
                
                let store = try context.fetch(request)
                
                guard !store.isEmpty else {
                    return completion(.empty)
                }
                
                completion(.found(items: store.map { $0.local }))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

@objc(ManagedTask)
private class ManagedTask: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var taskDescription: String?
    @NSManaged var date:  Date
    
    static func manage(_ task: LocalTask, in context: NSManagedObjectContext) {
        let managed = ManagedTask(context: context)
        managed.id = task.id
        managed.name = task.name
        managed.taskDescription = task.description
        managed.date = task.date        
    }
    
    var local: LocalTask {
        LocalTask(id: id, name: name, description: taskDescription, date: date)
    }
}

private extension NSPersistentContainer {
    enum LoadingError: Error {
        case modelNotFound
        case failedToLoadPersistentStores(Error)
    }
    
    static func load(modelName name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        
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
