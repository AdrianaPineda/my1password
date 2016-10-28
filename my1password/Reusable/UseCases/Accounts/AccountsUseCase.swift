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

    private let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    func loadAccounts() -> [NSManagedObject] {

        let managedContext = appDelegate.managedObjectContext

        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Account")

        do {

            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                return results
            }

        } catch {
            return []
        }
        
        return []
    }

}
