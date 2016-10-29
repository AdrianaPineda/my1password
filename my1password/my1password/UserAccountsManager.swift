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

    let currentAccountId: String = "USER_ACCOUNT_ID_"
    let currentAccountUsername: String = "USER_ACCOUNT_USERNAME_"
    let currentAccountPassword: String = "USER_ACCOUNT_PASSWORD_"
    let currentAccountUrl: String = "USER_ACCOUNT_URL_"
    let currentUserKey: String = "USER"
    let currentUserEmail: String = "USER_EMAIL"
    let currentUserPassword: String = "USER_PASSWORD"
    let currentUserAccounts: String = "USER_ACCOUNTS"

    let keychainServiceId: String = "com.adrianapineda"

    var user: User? = nil
    
    class var userAccounts: UserAccountsManager {
        return sharedInstance
    }

    // MARK: - Load data
    func loadUserAccountsFromConfig() -> Void {

        let userAccouts: [Account] = self.loadAccounts()

        if let currentUser: User = self.loadUser(withAccounts: userAccouts) {
            self.user = currentUser
        }

    }

    fileprivate func loadAccounts() -> [Account] {

        let userDefaults = UserDefaults.standard

        if let userDict: [String: AnyObject] = userDefaults.object(forKey: currentUserKey) as? [String: AnyObject] {

            return self.loadAccounts(fromUserDict: userDict)
        }

        return []
    }

    fileprivate func loadAccounts(fromUserDict userDict:[String: AnyObject]) -> [Account] {

        var accounts: [Account] = []

        if let userAccounts: [[String:AnyObject]] = userDict[currentUserAccounts] as? [[String:AnyObject]] {

            var index: Int = 0
            for account: [String:AnyObject] in userAccounts {

                if let currentAccount = self.loadAccount(fromAccountData: account, atIndex: index) {
                    accounts.append(currentAccount)
                }

                index += 1

            }
        }

        return accounts
    }

    fileprivate func loadAccount(fromAccountData data: [String: AnyObject], atIndex index:Int) -> Account? {

        let accountId: String? = data[currentAccountId + String(index)] as? String
        let accountUsername: String? = data[currentAccountUsername + String(index)] as? String
        let accountPassword: String? = self.getSensitiveData(forKey: currentAccountPassword + String(index))
        let accountUrl: String? = data[currentAccountUrl+String(index)] as? String

        if accountUsername != nil && accountPassword != nil  && accountUrl != nil && accountId != nil {

            let currentUserAccount: Account = Account(username: accountUsername!, password: accountPassword!, url: accountUrl!, id: Int(accountId!)!)
            return currentUserAccount
        }

        return nil

    }

    fileprivate func loadUser(withAccounts accounts:[Account]) -> User? {

        let userDefaults: UserDefaults = UserDefaults.standard

        if let currentUserDict: [String: AnyObject] = userDefaults.object(forKey: currentUserKey) as? [String: AnyObject] {

            let userEmail: String? = currentUserDict[currentUserEmail] as? String
            let password: String? = self.getSensitiveData(forKey: currentUserPassword)

            if userEmail != nil && password != nil {
                return User(email: userEmail!, password: password!, accounts: accounts)
            }

        }

        return nil

    }

    // MARK: - Get Accounts
    func getUserAccounts() -> [Account] {
        
        if let currentUser = user {
            
            return currentUser.getAccounts()
        }
        
        return []
    }

    // MARK: - Configure User
    func configureUser(withEmail email: String, andPassword password: String) {
        let user: User = User(email: email, password: password)
        self.user = user

        self.saveUser()
    }

    fileprivate func saveUser() {

        if let currentUser = user {

            let userDefaults = UserDefaults.standard

            let userDict: NSMutableDictionary = NSMutableDictionary()
            userDict.setObject(currentUser.getEmail(), forKey: currentUserEmail as NSCopying)

            self.saveSensitiveData(currentUser.getPassword(), forKey: currentUserPassword)

            userDefaults.set(userDict, forKey: currentUserKey)
            userDefaults.synchronize()
        }
    }

    // MARK: - Add Account
    func addAccount(withUsername username: String, password: String, url: String) -> Bool {

        if let currentUser: User = self.user {

            currentUser.addAccount(withUsername: username, password: password, url: url)
            self.saveAccounts()
            return true

        }

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

        if let currentUser = user {

            let currentAccountId = currentAccount!.getId()
            currentUser.updateAccount(account!, forAccountId: currentAccountId)
            self.saveAccounts()

            return true
        }

        return false
    }

    fileprivate func saveAccounts() {

        if self.user != nil {

            let userDefaults: UserDefaults = UserDefaults.standard

            if let userDict:[String: AnyObject] = userDefaults.object(forKey: currentUserKey) as? [String: AnyObject] {

                let mutableUserDict: NSMutableDictionary = self.saveAccounts(inUserDict: userDict)

                // Save info in userDefaults
                self.saveUserDictInUserDefaults(mutableUserDict)

            }

        }
    }

    fileprivate func saveAccounts(inUserDict userDict:[String: AnyObject]) -> NSMutableDictionary {

        if let currentUser = user {

            let mutableUserDict: NSMutableDictionary = NSMutableDictionary(dictionary: userDict)

            var currentAccountsArray: [[String: String]] = []

            var index: Int = 0
            for account: Account in currentUser.getAccounts() {

                let currentAccountDict: [String: String] = self.getAccountDict(fromAccount: account, atIndex: index)
                currentAccountsArray.append(currentAccountDict)

                self.saveSensitiveData(account.getPassword(), forKey: currentAccountPassword + String(index))

                index += 1

            }

            mutableUserDict[currentUserAccounts] = currentAccountsArray

            return mutableUserDict
        }

        return NSMutableDictionary()
    }

    fileprivate func saveUserDictInUserDefaults(_ userDict:NSDictionary) {

        // Save info in userDefaults
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: currentUserKey)
        userDefaults.set(userDict, forKey: currentUserKey)
        userDefaults.synchronize()

    }

    fileprivate func getAccountDict(fromAccount account: Account, atIndex index:Int) -> [String: String] {

        let currentAccountIdKey = currentAccountId + String(index)
        let currentAccountDict: [String: String] = [currentAccountIdKey: String(account.getId()), currentAccountUsername + String(index): account.getUsername(), currentAccountUrl + String(index): account.getUrl()]
        return currentAccountDict

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
