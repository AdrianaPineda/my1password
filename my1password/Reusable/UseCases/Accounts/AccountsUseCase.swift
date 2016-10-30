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

    fileprivate let accountEntityName = "Account"
    fileprivate let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    func loadAccounts() -> [Account] {

        let managedContext = appDelegate.managedObjectContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: accountEntityName)

        do {

            if let results = try managedContext.fetch(fetchRequest) as? [Account] {
                return results
            }

        } catch {
            return []
        }

        return []
    }

    func addAccount(_ username: String, password: String, url: String) -> Bool {

        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: accountEntityName, in: managedContext)

        let account = NSManagedObject(entity: entity!, insertInto: managedContext)
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
    
    func updateAccount(_ account: NSManagedObject, username: String, password: String, url: String) -> Bool {
        
        account.setValue(username, forKey: "username")
        account.setValue(password, forKey: "password")
        account.setValue(username, forKey: "url")
        
        do {
            
            let managedContext = appDelegate.managedObjectContext
            
            try managedContext.save()
            
            return true
            
        } catch {
            return false
        }
    }

}
