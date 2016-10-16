//
//  Account+CoreDataProperties.swift
//  my1password
//
//  Created by Adriana Pineda on 10/15/16.
//  Copyright © 2016 Adriana Pineda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Account {

    @NSManaged var password: String?
    @NSManaged var url: String?
    @NSManaged var username: String?

}
