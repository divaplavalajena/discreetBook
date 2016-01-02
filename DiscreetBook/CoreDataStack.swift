//
//  CoreDataStack.swift
//  discreetBook
//
//  Created by Jena Grafton on 12/4/15.
//  Copyright © 2015 Bella Voce Productions. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    static let moduleName = "discreetBook"
    
    func saveMainContext() {
        guard managedObjectContext.hasChanges || saveManagedObjectContext.hasChanges else {
            return
        }
        
        managedObjectContext.performBlockAndWait() {
            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError("Error saving main managed object context! \(error)")
            }
        }
        
        saveManagedObjectContext.performBlock() {
            do {
                try self.saveManagedObjectContext.save()
            } catch {
                fatalError("Error saving private managed object context! \(error)")
            }
        }
    }

    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let persistentStoreURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(moduleName).sqlite")
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType,
                configuration: nil,
                URL: persistentStoreURL,
                options: [NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: false])
        } catch {
            fatalError("Persistent store error! \(error)")
        }
        
        return coordinator
    }()
    
    private lazy var saveManagedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        return moc
    }()

    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.parentContext = self.saveManagedObjectContext
        return managedObjectContext
    }()
    
    
    
    
}
