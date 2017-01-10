//
//  User+CoreDataClass.swift
//  my1password
//
//  Created by Adriana Pineda on 10/29/16.
//  Copyright © 2016 Adriana Pineda. All rights reserved.
//

import Foundation
import CoreData

public class User: NSManagedObject {

    @NSManaged public var id: NSNumber?
    @NSManaged public var username: String?
    @NSManaged public var accounts: Account?

    private static let userEntityName = "User"
    private static let accountsRelationshipName = "accounts"

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: userEntityName);
    }

    public class func entity(forManagedContext managedContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: userEntityName, in: managedContext)
    }

    func addAccount(account: Account) {
        let accounts = self.mutableSetValue(forKey: User.accountsRelationshipName)
        accounts.add(account)
    }

}
