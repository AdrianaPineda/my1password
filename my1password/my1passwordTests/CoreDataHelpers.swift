//
//  CoreDataHelpers.swift
//  my1password
//
//  Created by Adriana Pineda on 10/29/16.
//  Copyright © 2016 Adriana Pineda. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelpers: NSObject {

    public func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {

        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }

        let managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
    }

}
