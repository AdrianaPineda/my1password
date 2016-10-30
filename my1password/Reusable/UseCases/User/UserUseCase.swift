//
//  UserUseCase.swift
//  my1password
//
//  Created by Adriana Pineda on 10/29/16.
//  Copyright © 2016 Adriana Pineda. All rights reserved.
//

import UIKit
import CoreData
import Locksmith

class UserUseCase: NSObject {

    fileprivate var user: User? = nil

    let keychainServiceId: String = "com.adrianapineda"

    fileprivate let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    func saveUser(username: String, password: String) -> Bool {

        let managedContext = appDelegate.managedObjectContext

        guard let entity = User.entity(forManagedContext: managedContext) else {
            return false
        }

        let user = User(entity: entity, insertInto: managedContext)
        user.username = username

        do {

            try managedContext.save()

            let sensitiveDataSaved = self.saveSensitiveData(password, forKey: username)

            if sensitiveDataSaved {
                self.user = user
                return true
            }

        } catch {
            NSLog("ERROR")
            return false
        }

        return false
    }

    func isMasterPasswordValid(password: String) -> Bool {

        guard let data: [String: Any] = Locksmith.loadDataForUserAccount(userAccount: keychainServiceId) else {
            return false
        }
        // TODO: support several users
        for key in data.keys {
            if data[key] as? String == password {
                return true
            }
        }

        return false
    }

    fileprivate func saveSensitiveData(_ data: String, forKey key: String) -> Bool {

        do {

            try Locksmith.saveData(data: [key: data], forUserAccount: keychainServiceId)

            return true

        } catch {
            NSLog("ERROR")
            
            return false
        }
    }

    func loadUser() -> User? {

        if let user = self.user {
            return user
        }

        let managedContext = appDelegate.managedObjectContext

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {

            let user = try managedContext.fetch(fetchRequest)

            return user[0]

        } catch {
            return nil
        }
    }

}
