//
//  Account+CoreDataProperties.swift
//  my1password
//
//  Created by Adriana Pineda on 10/29/16.
//  Copyright © 2016 Adriana Pineda. All rights reserved.
//

import Foundation
import CoreData


extension Account {

    private static let accountEntityName = "Account"

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: accountEntityName);
    }

    public class func entity(forManagedContext managedContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: accountEntityName, in: managedContext)
    }

    @NSManaged public var password: String?
    @NSManaged public var url: String?
    @NSManaged public var username: String?

}
