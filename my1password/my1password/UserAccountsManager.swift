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
   
    func loadUserAccountsFromConfig() -> Void {

        let userAccouts: [Account] = self.loadAccounts()

        if let currentUser: User = self.loadUser(withAccounts: userAccouts)! as User {
            self.user = currentUser
        }

    }
    
    func getUserAccounts() -> NSArray {
        
        if let currentUser = user {
            
            return currentUser.accounts
        }
        
        return NSArray()
    }
    
    func addAccount(account: Account) -> Bool {
        
        user?.addAccount(account)
        self.saveAccount()
        return true
    }

    func configureUser(withEmail email: String, andPassword password: String) {
        let user: User = User(email: email, password: password, accounts: [])
        self.user = user

        self.saveUser()
    }

    func saveUser() {

        if let currentUser = user {

            let userDefaults = NSUserDefaults.standardUserDefaults()

            let userDict: NSMutableDictionary = NSMutableDictionary()
            userDict.setObject(currentUser.email, forKey: currentUserEmail)

            self.saveSensitiveData(currentUser.password, forKey: currentUserPassword)
//            userDict.setObject(currentUser.password, forKey: currentUserPassword)

//            var accounts:[[String: AnyObject]] = []
//            let accountsSize = currentUser.accounts.count
//            for var index = 0; index < accountsSize; index++ {
//
//                let currentAccount: Account = currentUser.accounts[index]
//                let currentAccountDict: [String: String] = [currentAccountUsername + String(index): currentAccount.username, currentAccountUrl + String(index): currentAccount.url]
//                self.saveSensitiveData(currentAccount.password, forKey: currentAccountPassword + String(index))
//
//                accounts.append(currentAccountDict)
//
////                let currentAccountDict = self.saveAccountForUserAndIndex(currentUser, index: index)
////                userDict.addEntriesFromDictionary(currentAccountDict as [NSObject : AnyObject])
//
//            }
//
//            if accountsSize > 0 {
//                userDict.setObject(accounts, forKey: currentUserAccounts)
//            }

            userDefaults.setObject(userDict, forKey: currentUserKey)
            userDefaults.synchronize()
        }
    }

    func saveAccount() {

        if let currentUser = user {

            let userDefaults = NSUserDefaults.standardUserDefaults()

            let accountsSize = currentUser.accounts.count
            let indexForAccount = accountsSize - 1

            let currentUserDict = NSMutableDictionary(dictionary: userDefaults.objectForKey(currentUserKey) as! NSDictionary)
            var accountsSaved: [[String: AnyObject]] = []

            if let currentAccounts: [[String:AnyObject]] = currentUserDict[currentUserAccounts] as? [[String: AnyObject]] {
                if currentAccounts.count > 0 {
                    accountsSaved = currentAccounts
                }
            }

            let currentAccount: Account = currentUser.accounts[indexForAccount]
            let currentAccountDict: [String: String] = [currentAccountUsername + String(indexForAccount): currentAccount.username, currentAccountUrl + String(indexForAccount): currentAccount.url]
            accountsSaved.append(currentAccountDict)
            self.saveSensitiveData(currentAccount.password, forKey: currentAccountPassword + String(indexForAccount))

            currentUserDict[currentUserAccounts] = accountsSaved
            userDefaults.removeObjectForKey(currentUserKey)
            userDefaults.setObject(currentUserDict, forKey: currentUserKey)
            userDefaults.synchronize()
        }

    }

//    func saveAccountForUserAndIndex(user: User, index: Int) -> NSMutableDictionary! {
//
//        let userDict: NSMutableDictionary = NSMutableDictionary()
//
//        let currentAccount: Account = user.accounts[index]
//
//        userDict.setObject(currentAccount.username, forKey: currentAccountUsername + String(index))
//
//        self.saveSensitiveData(currentAccount.password, forKey: currentAccountPassword + String(index))
////        userDict.setObject(currentAccount.password, forKey: currentAccountPassword + String(index))
//
//        userDict.setObject(currentAccount.url, forKey: currentAccountUrl + String(index))
//
//        return userDict
//    }

    func loadAccounts() -> [Account] {

        var accounts: [Account] = []

        let userDefaults = NSUserDefaults.standardUserDefaults()

        if let userDict: [String: AnyObject] = userDefaults.objectForKey(currentUserKey) as? [String: AnyObject] {


            if let userAccounts: [[String:AnyObject]] = userDict[currentUserAccounts] as? [[String:AnyObject]] {

                var index: Int = 0
                for account: [String:AnyObject] in userAccounts {
                    // TODO WHAT IF NO ACCOUNT IS FOUND?
                    let accountUsername: String = account[currentAccountUsername + String(index)] as! String

                    let accountPassword: String = self.getSensitiveData(forKey: currentAccountPassword + String(index))
                    let accountUrl: String = account[currentAccountUrl+String(index)] as! String

                    let currentUserAccount: Account = Account(username: accountUsername, password: accountPassword, url: accountUrl)

                    accounts.append(currentUserAccount)

                    index++

                }
            }
        }

        return accounts
    }

    func loadUser(withAccounts accounts:[Account]) -> User? {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

        if let currentUserDict: [String: AnyObject] = userDefaults.objectForKey(currentUserKey) as? [String: AnyObject] {

            let userEmail: String = currentUserDict[currentUserEmail] as! String
            let password: String = self.getSensitiveData(forKey: currentUserPassword)

            return User(email: userEmail, password: password, accounts: accounts)

        } else {
            return nil
        }

    }

    func saveSensitiveData(data: String, forKey key: String) {
        SSKeychain.setPassword(data, forService: keychainServiceId, account: key)
    }

    func getSensitiveData(forKey key: String) -> String {
        if let currentInfo: String = SSKeychain.passwordForService(keychainServiceId, account: key) {
            return currentInfo
        }

        return ""
    }

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
