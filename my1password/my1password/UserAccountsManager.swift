//
//  UserAccountsManager.swift
//  my1password
//
//  Created by Adriana Pineda on 3/23/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit
import SSKeychain

private let sharedInstance = UserAccountsManager()

class UserAccountsManager: NSObject {

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

    private func loadAccounts() -> [Account] {

        let userDefaults = NSUserDefaults.standardUserDefaults()

        if let userDict: [String: AnyObject] = userDefaults.objectForKey(currentUserKey) as? [String: AnyObject] {

            return self.loadAccounts(fromUserDict: userDict)
        }

        return []
    }

    private func loadAccounts(fromUserDict userDict:[String: AnyObject]) -> [Account] {

        var accounts: [Account] = []

        if let userAccounts: [[String:AnyObject]] = userDict[currentUserAccounts] as? [[String:AnyObject]] {

            var index: Int = 0
            for account: [String:AnyObject] in userAccounts {

                if let currentAccount = self.loadAccount(fromAccountData: account, atIndex: index) {
                    accounts.append(currentAccount)
                }

                index++

            }
        }

        return accounts
    }

    private func loadAccount(fromAccountData data: [String: AnyObject], atIndex index:Int) -> Account? {

        let accountUsername: String? = data[currentAccountUsername + String(index)] as? String
        let accountPassword: String? = self.getSensitiveData(forKey: currentAccountPassword + String(index))
        let accountUrl: String? = data[currentAccountUrl+String(index)] as? String

        if accountUsername != nil && accountPassword != nil  && accountUrl != nil {

            let currentUserAccount: Account = Account(username: accountUsername!, password: accountPassword!, url: accountUrl!)
            return currentUserAccount
        }

        return nil

    }

    private func loadUser(withAccounts accounts:[Account]) -> User? {

        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

        if let currentUserDict: [String: AnyObject] = userDefaults.objectForKey(currentUserKey) as? [String: AnyObject] {

            let userEmail: String? = currentUserDict[currentUserEmail] as? String
            let password: String? = self.getSensitiveData(forKey: currentUserPassword)

            if userEmail != nil && password != nil {
                return User(email: userEmail!, password: password!, accounts: accounts)
            }

        }

        return nil

    }

    // MARK: - Get Accounts
    func getUserAccounts() -> NSArray {
        
        if let currentUser = user {
            
            return currentUser.accounts
        }
        
        return NSArray()
    }

    // MARK: - Configure User
    func configureUser(withEmail email: String, andPassword password: String) {
        let user: User = User(email: email, password: password)
        self.user = user

        self.saveUser()
    }

    private func saveUser() {

        if let currentUser = user {

            let userDefaults = NSUserDefaults.standardUserDefaults()

            let userDict: NSMutableDictionary = NSMutableDictionary()
            userDict.setObject(currentUser.email, forKey: currentUserEmail)

            self.saveSensitiveData(currentUser.password, forKey: currentUserPassword)

            userDefaults.setObject(userDict, forKey: currentUserKey)
            userDefaults.synchronize()
        }
    }

    // MARK: - Add Account
    func addAccount(account: Account) -> Bool {

        if let currentUser: User = self.user {

            currentUser.addAccount(account)
            self.saveAccount(account)
            return true

        }

        return false
    }

//    private func saveAccount(currentAccount: Account) {
//
//        if self.user != nil {
//
//            let currentUserDict = self.getUserInfoDictionary(withAccount: currentAccount)
//
//            // Save info in userDefaults
//            let userDefaults = NSUserDefaults.standardUserDefaults()
//            userDefaults.removeObjectForKey(currentUserKey)
//            userDefaults.setObject(currentUserDict, forKey: currentUserKey)
//            userDefaults.synchronize()
//
//            // Save info in the keychain
//            let indexForAccount = self.user!.accounts.count - 1
//            self.saveSensitiveData(currentAccount.password, forKey: currentAccountPassword + String(indexForAccount))
//        }
//
//    }
//
//    private func getUserInfoDictionary(withAccount currentAccount: Account) -> NSMutableDictionary {
//
//        if let currentUser = self.user {
//
//            let userDefaults = NSUserDefaults.standardUserDefaults()
//
//            if let currentUserDict: [String:AnyObject] = userDefaults.objectForKey(currentUserKey) as? [String:AnyObject] {
//
//                var accountsSaved: [[String: AnyObject]] = self.getSavedAccounts(fromUserDict: currentUserDict)
//
//                let indexForAccount = currentUser.accounts.count - 1
//                let currentAccountDict: [String: String] = self.getAccountDict(fromAccount: currentAccount, atIndex: indexForAccount)
//                accountsSaved.append(currentAccountDict)
//
//                let newUserDict = NSMutableDictionary(dictionary: currentUserDict)
//                newUserDict[currentUserAccounts] = accountsSaved
//
//                return newUserDict
//            }
//
//        }
//
//        return NSMutableDictionary()
//    }
//
//    private func getSavedAccounts(fromUserDict currentUserDict: [String:AnyObject]) -> [[String:AnyObject]] {
//
//        var accountsSaved: [[String: AnyObject]] = []
//
//        if let currentAccounts: [[String:AnyObject]] = currentUserDict[currentUserAccounts] as? [[String: AnyObject]] {
//            if currentAccounts.count > 0 {
//                accountsSaved = currentAccounts
//            }
//        }
//        return accountsSaved
//    }

    // MARK: - Update Account
    func updateAccount(account: Account) -> Bool {

        if let currentUser = user {

            let index: Int = currentUser.accounts.indexOf(account)!
            currentUser.accounts[index] = account

            self.saveAccounts()

            return true
        }

        return false
    }

    private func saveAccounts() {

        if let currentUser = user {

            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if let userDict:[String: AnyObject] = userDefaults.objectForKey(currentUserKey) as? [String: AnyObject] {

                let mutableUserDict: NSMutableDictionary = NSMutableDictionary(dictionary: userDict)

                var currentAccountsArray: [[String: String]] = []

                var index: Int = 0
                for account: Account in currentUser.accounts {

                    let currentAccountDict: [String: String] = self.getAccountDict(fromAccount: account, atIndex: index)
                    currentAccountsArray.append(currentAccountDict)

                    self.saveSensitiveData(account.password, forKey: currentAccountPassword + String(index))

                    index++

                }

                mutableUserDict[currentUserAccounts] = currentAccountsArray

                // Save info in userDefaults
                self.saveUserDictInUserDefaults(mutableUserDict)

            }

        }
    }

    private func saveUserDictInUserDefaults(userDict:NSDictionary) {

        // Save info in userDefaults
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(currentUserKey)
        userDefaults.setObject(userDict, forKey: currentUserKey)
        userDefaults.synchronize()

    }

    private func getAccountDict(fromAccount account: Account, atIndex index:Int) -> [String: String] {

        let currentAccountDict: [String: String] = [currentAccountUsername + String(index): account.username, currentAccountUrl + String(index): account.url]
        return currentAccountDict

    }

    // MARK: - Keychain
    private func getSensitiveData(forKey key: String) -> String? {
        if let currentInfo: String = SSKeychain.passwordForService(keychainServiceId, account: key) {
            return currentInfo
        }

        return nil
    }

    private func saveSensitiveData(data: String, forKey key: String) {
        SSKeychain.setPassword(data, forService: keychainServiceId, account: key)
    }

    // MARK: - Master Password
    func isMasterPasswordValid(forPassword password: String) -> Bool {

        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let _: [String: AnyObject] = userDefaults.objectForKey(currentUserKey) as? [String: AnyObject] {

            let savedPassword: String? = SSKeychain.passwordForService(keychainServiceId, account: currentUserPassword)

            if savedPassword != nil && password == savedPassword {
                return true
            }
        }

        return false
    }
}
