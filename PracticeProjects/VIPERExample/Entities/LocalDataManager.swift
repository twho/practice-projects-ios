//
//  LocalDataManager.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import CoreData

class ToDoListLocalDataManager: ToDoListLocalDataManagerInputProtocol {
    
    func retrieveToDoList() throws -> [Task] {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        let request: NSFetchRequest<Task> = NSFetchRequest(entityName: String(describing: Task.self))
        return try managedOC.fetch(request)
    }
    
    func saveTask(_ name: String, _ content: String) throws {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        if let newTask = NSEntityDescription.entity(forEntityName: "Task", in: managedOC) {
            let task = Task(entity: newTask, insertInto: managedOC)
            task.name = name
            task.content = content
            task.timestamp = Date()
            try managedOC.save()
        }
        throw PersistenceError.couldNotSaveObject
    }
}
