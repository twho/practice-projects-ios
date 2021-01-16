//
//  CoreDataStore.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/15/21.
//

import CoreData
import UIKit

enum PersistenceError: Error {
    case managedObjectContextNotFound
    case couldNotSaveObject
    case objectNotFound
    case couldNotDeleteObject
}

class CoreDataStore {
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.persistentStoreCoordinator
        }
        return nil
    }
    
    static var managedObjectModel: NSManagedObjectModel? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.managedObjectModel
        }
        return nil
    }
    
    static var managedObjectContext: NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil
    }
    
}

