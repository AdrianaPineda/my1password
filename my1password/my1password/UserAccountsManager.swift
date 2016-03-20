//
//  UserAccountsManager.swift
//  my1password
//
//  Created by Adriana Pineda on 3/23/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

private let sharedInstance = UserAccountsManager()

class UserAccountsManager: NSObject {
    
    let currentAccountUsername: String = "USER_ACCOUNT_USERNAME_"
    let currentAccountPassword: String = "USER_ACCOUNT_PASSWORD_"
    let currentAccountUrl: String = "USER_ACCOUNT_URL_"
    let currentUserKey: String = "USER"
    let currentUserEmail: String = "USER_EMAIL"
    let currentUserPassword: String = "USER_PASSWORD"
    let currentUserAccounts: String = "USER_ACCOUNTS"

    var user: User? = nil
    
    class var userAccounts: UserAccountsManager {
        return sharedInstance
    }
   
    func loadUserAccountsFromConfig() -> Void {
        
        let userAccouts: [Account] = self.loadAccounts()
        user = User(email: "", password: "", accounts: userAccouts)
        
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

    func saveUser() {

        if let currentUser = user {

            let userDefaults = NSUserDefaults.standardUserDefaults()

            let userDict: NSMutableDictionary = NSMutableDictionary()
            userDict.setObject(currentUser.email, forKey: currentUserEmail)
            userDict.setObject(currentUser.password, forKey: currentUserPassword)
            userDict.setObject(currentUser.accounts.count, forKey: currentUserAccounts)

            let accountsSize = currentUser.accounts.count
            for var index = 0; index < accountsSize; index++ {

                let currentAccountDict = self.saveAccountForUserAndIndex(currentUser, index: index)
                userDict.addEntriesFromDictionary(currentAccountDict as [NSObject : AnyObject])

            }

            userDefaults.setObject(userDict, forKey: "USER")
            userDefaults.synchronize()
        }
    }

    func saveAccount() {

        if let currentUser = user {

            let userDefaults = NSUserDefaults.standardUserDefaults()

            let accountsSize = currentUser.accounts.count
            let indexForAccount = accountsSize - 1

            let accountDict = self.saveAccountForUserAndIndex(currentUser, index: indexForAccount)

            let currentUserDict = userDefaults.objectForKey(currentUserKey)
            currentUserDict?.addEntriesFromDictionary(accountDict as [NSObject : AnyObject])

            userDefaults.removeObjectForKey(currentUserKey)
            userDefaults.setObject(currentUserDict, forKey: currentUserKey)
            userDefaults.synchronize()
        }

    }

    func saveAccountForUserAndIndex(user: User, index: Int) -> NSMutableDictionary! {

        let userDict: NSMutableDictionary = NSMutableDictionary()

        let currentAccount: Account = user.accounts[index]

        userDict.setObject(currentAccount.username, forKey: currentAccountUsername + String(index))
        userDict.setObject(currentAccount.password, forKey: currentAccountPassword + String(index))
        userDict.setObject(currentAccount.url, forKey: currentAccountUrl + String(index))

        return userDict
    }

    func loadAccounts() -> [Account] {

        var accounts: [Account] = []

        let userDefaults = NSUserDefaults.standardUserDefaults()

        if let numberOfAccounts: Int = userDefaults.objectForKey(currentUserAccounts) as? Int {

            if let userDict: NSDictionary = userDefaults.objectForKey(currentUserKey) as? NSDictionary {

                let index: Int = 0

                while index < numberOfAccounts {

                    let accountUsername: String = userDict.objectForKey(currentAccountUsername + String(index)) as! String
                    let accountPassword: String = userDict.objectForKey(currentAccountPassword + String(index)) as! String
                    let accountUrl: String = userDict.objectForKey(currentAccountUrl + String(index)) as! String

                    let currentUserAccount: Account = Account(username: accountUsername, password: accountPassword, url: accountUrl)

                    accounts.append(currentUserAccount)
                }

            }

        }

        return accounts
    }
}
