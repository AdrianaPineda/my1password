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
    fileprivate let usersAPI = UserAPIClient()

    let keychainServiceId: String = "com.adrianapineda"

    fileprivate let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    func saveUserLocally(userDTO: UserDTO) -> Bool {

        guard let userId = userDTO.getId() else {
            return false
        }

        let managedContext = self.appDelegate.managedObjectContext

        guard let entity = User.entity(forManagedContext: managedContext) else {
            return false
        }

        let user = User(entity: entity, insertInto: managedContext)
        user.id = NSNumber(integerLiteral: userId)
        user.username = userDTO.getUsername()

        do {

            try managedContext.save()

            let sensitiveDataSaved = self.saveSensitiveData(userDTO.getPassword(), forKey: userDTO.getUsername())

            if sensitiveDataSaved {
                self.user = user
                return true
            }

        } catch {
            NSLog("ERROR")
        }

        return false

    }

    func createUser(userDTO: UserDTO, handler: @escaping ((Bool) -> (Void))) {

        // Make API call to create user
        usersAPI.createUser(userDTO: userDTO) { [unowned self] (userId) -> (Void) in

            // Save user locally
            let userSavedLocally = self.saveUserLocally(userDTO: userDTO)
            handler(userSavedLocally)

        }
    }

    func isUserSavedLocally(password: String, user: String) -> Bool {

        guard let data: [String: Any] = Locksmith.loadDataForUserAccount(userAccount: user) else {
            return false
        }

        for key in data.keys {

            if key != "password" {
                continue
            }

            if data[key] as? String == password {
                return true
            }
        }

        return false
    }

    func isMasterPasswordValid(password: String, forUser user: String, handler: @escaping ((Bool) -> (Void))) {

        // 1. Check if user has been saved locally
        if isUserSavedLocally(password: password, user: user) {
            handler(true)
            return
        }

        // 2. Make API to get user
        usersAPI.getUser(withUsername: user) { [unowned self] (user) -> (Void) in

            guard let user = user else {
                handler(false)
                return
            }

            guard user.getPassword() == password else {
                handler(false)
                return
            }

            let userSavedLocally = self.saveUserLocally(userDTO: user)
            handler(userSavedLocally)
            return

        }

    }

    fileprivate func saveSensitiveData(_ data: String, forKey key: String) -> Bool {

        do {

            try Locksmith.saveData(data: ["password": data], forUserAccount: key)

            return true

        } catch {
            NSLog("ERROR")
            
            return false
        }
    }

    func loadUser(withUsername username: String?) -> User? {

        guard let username = username else {
            return nil
        }

        if let user = self.user {
            return user
        }

        let managedContext = appDelegate.managedObjectContext

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {

            let users = try managedContext.fetch(fetchRequest)

            for currentUser in users {
                if currentUser.username == username {
                    return currentUser
                }
            }

           return nil

        } catch {
            return nil
        }
    }

}
