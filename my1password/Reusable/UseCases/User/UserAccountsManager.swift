//
//  UserAccountsManager.swift
//  my1password
//
//  Created by Adriana Pineda on 3/23/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit
import Locksmith

private let sharedInstance = UserAccountsManager()

class UserAccountsManager: NSObject {

    let currentUserKey: String = "USER"
    let currentUserPassword: String = "USER_PASSWORD"

    let keychainServiceId: String = "com.adrianapineda"

    var user: User? = nil
    
    class var userAccounts: UserAccountsManager {
        return sharedInstance
    }

    // MARK: - Load data
    func loadUserAccountsFromConfig() -> Void {

//        let userAccouts: [Account] = self.loadAccounts()
//
//        if let currentUser: User = self.loadUser(withAccounts: userAccouts) {
//            self.user = currentUser
//        }

    }

    fileprivate func loadUser(withAccounts accounts:[Account]) -> User? {

//        let userDefaults: UserDefaults = UserDefaults.standard
//
//        if let currentUserDict: [String: AnyObject] = userDefaults.object(forKey: currentUserKey) as? [String: AnyObject] {
//
//            let userEmail: String? = currentUserDict[currentUserEmail] as? String
//            let password: String? = self.getSensitiveData(forKey: currentUserPassword)
//
//            if userEmail != nil && password != nil {
//                return User(email: userEmail!, password: password!, accounts: accounts)
//            }
//
//        }

        return nil

    }

    // MARK: - Get Accounts
    func getUserAccounts() -> [Account] {
        
//        if let currentUser = user {
//            
//            return currentUser.getAccounts()
//        }
//        
        return []
    }

    // MARK: - Configure User
    func configureUser(withEmail email: String, andPassword password: String) {
//        let user: User = User(email: email, password: password)
//        self.user = user
//
//        self.saveUser()
    }

    fileprivate func saveUser() {

//        if let currentUser = user {
//
//            let userDefaults = UserDefaults.standard
//
//            let userDict: NSMutableDictionary = NSMutableDictionary()
//            userDict.setObject(currentUser.getEmail(), forKey: currentUserEmail as NSCopying)
//
//            self.saveSensitiveData(currentUser.getPassword(), forKey: currentUserPassword)
//
//            userDefaults.set(userDict, forKey: currentUserKey)
//            userDefaults.synchronize()
//        }
    }

    // MARK: - Add Account
    func addAccount(withUsername username: String, password: String, url: String) -> Bool {

//        if let currentUser: User = self.user {
//
//            currentUser.addAccount(withUsername: username, password: password, url: url)
//            self.saveAccounts()
//            return true
//
//        }

        return false
    }

    // MARK: - Update Account
    func updateAccount(_ account: Account?, forCurrentAccount currentAccount: Account?) -> Bool {

        if account == nil {
            return false
        }

        if currentAccount == nil {
            return false
        }

//        if let currentUser = user {

//            let currentAccountId = currentAccount!.getId()
//            currentUser.updateAccount(account!, forAccountId: currentAccountId)
//            self.saveAccounts()
//
//            return true
//        }

        return false
    }

//    fileprivate func saveAccounts() {
//
//        if self.user != nil {
//
//            let userDefaults: UserDefaults = UserDefaults.standard
//
//            if let userDict:[String: AnyObject] = userDefaults.object(forKey: currentUserKey) as? [String: AnyObject] {
//
//                let mutableUserDict: NSMutableDictionary = self.saveAccounts(inUserDict: userDict)
//
//                // Save info in userDefaults
//                self.saveUserDictInUserDefaults(mutableUserDict)
//
//            }
//
//        }
//    }

    fileprivate func saveUserDictInUserDefaults(_ userDict:NSDictionary) {

        // Save info in userDefaults
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: currentUserKey)
        userDefaults.set(userDict, forKey: currentUserKey)
        userDefaults.synchronize()

    }

    // MARK: - Keychain
    fileprivate func getSensitiveData(forKey key: String) -> String? {

        if let data:[String: Any] = Locksmith.loadDataForUserAccount(userAccount: keychainServiceId) {

            return data[key] as? String
        }

        return nil
    }

    fileprivate func saveSensitiveData(_ data: String, forKey key: String) {

        do {

            try Locksmith.saveData(data: [key: data], forUserAccount: keychainServiceId)

        } catch {
            NSLog("ERROR")
        }
    }

    // MARK: - Master Password
    func isMasterPasswordValid(forPassword password: String) -> Bool {

        let userDefaults: UserDefaults = UserDefaults.standard
        if let _: [String: AnyObject] = userDefaults.object(forKey: currentUserKey) as? [String: AnyObject] {

            let savedPassword: String? = self.getSensitiveData(forKey: currentUserPassword)

            if savedPassword != nil && password == savedPassword {
                return true
            }
        }

        return false
    }
}
