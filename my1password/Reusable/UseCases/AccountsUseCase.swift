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

    func loadAccounts() -> [AnyObject] {

        guard let moct: NSManagedObjectContext = self.appDelegate.managedObjectContext else {
            return []
        }

        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Account")

        do {

            let results = try moct.executeFetchRequest(fetchRequest)

            return results

        } catch {
            return []
        }

        return []
    }

}
