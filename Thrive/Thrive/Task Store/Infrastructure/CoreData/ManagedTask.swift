//
//  ManagedTask.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 12/07/2023.
//

import CoreData

@objc(ManagedTask)
class ManagedTask: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var taskDescription: String?
    @NSManaged var date:  Date
}

extension ManagedTask {
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

extension ManagedTask {
    private static func createFetchRequest() -> NSFetchRequest<ManagedTask> {
        return NSFetchRequest<ManagedTask>(entityName: ManagedTask.entity().name!)
    }
    
    static func find(in context: NSManagedObjectContext) throws -> [ManagedTask] {
        let request = createFetchRequest()
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    static func find(_ task: LocalTask, in context: NSManagedObjectContext) throws -> ManagedTask? {
        let request = createFetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", task.id.uuidString)
        return try context.fetch(request).first
    }
}
