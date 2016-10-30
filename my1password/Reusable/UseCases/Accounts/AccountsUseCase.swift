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

    fileprivate let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    func loadAccounts(forUser user:User?) -> [Account] {

        let managedContext = appDelegate.managedObjectContext

        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()

        if let user = user {
            fetchRequest.predicate = NSPredicate(format: "user=%@", user)
        }

        do {

            return try managedContext.fetch(fetchRequest)

        } catch {
            return []
        }

    }

    func addAccount(_ username: String, password: String, url: String) -> Bool {

        let managedContext = appDelegate.managedObjectContext

        guard let entity = Account.entity(forManagedContext: managedContext) else {
            return false
        }

        let account = Account(entity: entity, insertInto: managedContext)
        account.username = username
        account.password = password
        account.url = url

        do {

            try managedContext.save()
            return true

        } catch {
            return false
        }
    }
    
    func updateAccount(_ account: Account, username: String, password: String, url: String) -> Bool {
        
        account.username = username
        account.password = password
        account.url = url
        
        do {
            
            let managedContext = appDelegate.managedObjectContext
            
            try managedContext.save()
            
            return true
            
        } catch {
            return false
        }
    }

}
