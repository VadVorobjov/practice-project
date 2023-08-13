//
//  ManagedTask.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 12/07/2023.
//

import CoreData

@objc(ManagedCommand)
class ManagedCommand: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var commandDescription: String?
    @NSManaged var date:  Date
}

extension ManagedCommand {
    static func manage(_ task: LocalTask, in context: NSManagedObjectContext) {
        let managed = ManagedCommand(context: context)
        managed.id = task.id
        managed.name = task.name
        managed.commandDescription = task.description
        managed.date = task.date
    }
    
    var local: LocalTask {
        LocalTask(id: id, name: name, description: commandDescription, date: date)
    }
}

extension ManagedCommand {
    private static func createFetchRequest() -> NSFetchRequest<ManagedCommand> {
        return NSFetchRequest<ManagedCommand>(entityName: ManagedCommand.entity().name!)
    }
    
    static func find(in context: NSManagedObjectContext) throws -> [ManagedCommand] {
        let request = createFetchRequest()
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    static func find(_ task: LocalTask, in context: NSManagedObjectContext) throws -> ManagedCommand? {
        let request = createFetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", task.id.uuidString)
        return try context.fetch(request).first
    }
}
