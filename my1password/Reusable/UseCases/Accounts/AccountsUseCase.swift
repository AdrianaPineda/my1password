//
//  AccountsUseCase.swift
//  my1password
//
//  Created by Adriana Pineda on 10/12/16.
//  Copyright © 2016 Adriana Pineda. All rights reserved.
//

import UIKit
import CoreData

class AccountsUseCase: NSObject {

    private let accountEntityName = "Account"
    private let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    func loadAccounts() -> [NSManagedObject] {

        let managedContext = appDelegate.managedObjectContext

        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: accountEntityName)

        do {

            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                return results
            }

        } catch {
            return []
        }

        return []
    }

    func addAccount(username: String, password: String, url: String) -> Bool {

        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName(accountEntityName, inManagedObjectContext: managedContext)

        let account = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        account.setValue(username, forKey: "username")
        account.setValue(password, forKey: "password")
        account.setValue(username, forKey: "url")

        do {

            try managedContext.save()
            return true

        } catch {
            return false
        }
    }

}
