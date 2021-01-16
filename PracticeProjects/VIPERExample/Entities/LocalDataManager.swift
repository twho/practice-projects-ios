//
//  LocalDataManager.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import CoreData

class ToDoListLocalDataManager: ToDoListLocalDataManagerInputProtocol {
    static let shared = ToDoListLocalDataManager()
    private init() {}
    
    func retrieveToDoList(_ keyword: String?) throws -> [Task] {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        let request: NSFetchRequest<Task> = NSFetchRequest(entityName: String(describing: Task.self))
        if let keyword = keyword {
            request.predicate = NSPredicate(format: "content contains[c] %@", keyword)
        }
        return try managedOC.fetch(request)
    }
    
    func deleteTaskInStorage(_ task: Task) throws {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        let request: NSFetchRequest<Task> = NSFetchRequest(entityName: String(describing: Task.self))
        request.predicate = NSPredicate(format: "id = %@", task.id.unsafelyUnwrapped)
        do {
            for task in try managedOC.fetch(request) {
                managedOC.delete(task)
            }
        } catch {
            throw PersistenceError.couldNotDeleteObject
        }
    }
    
    func saveTask(_ content: String) throws {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        if let newTask = NSEntityDescription.entity(forEntityName: "Task", in: managedOC) {
            let task = Task(entity: newTask, insertInto: managedOC)
            task.id = "\(UUID())"
            task.content = content
            task.timestamp = Date()
            try managedOC.save()
        } else {
            throw PersistenceError.couldNotSaveObject
        }
    }
    
    func updateTask(_ newTask: Task) throws {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        let request: NSFetchRequest<Task> = NSFetchRequest(entityName: String(describing: Task.self))
        request.predicate = NSPredicate(format: "id = %@", newTask.id.unsafelyUnwrapped)
        do {
            for task in try managedOC.fetch(request) {
                task.setValue(newTask.content, forKey: "content")
                task.setValue(newTask.timestamp, forKey: "timestamp")
            }
            try managedOC.save()
        } catch {
            throw PersistenceError.couldNotDeleteObject
        }
    }
}
