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
    
    var user: User? = nil
    
    class var userAccounts: UserAccountsManager {
        return sharedInstance
    }
   
    func loadUserAccountsFromConfig() -> Void {
        
        user = User(email: "", password: "", accounts: NSMutableArray())
        
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
            userDict.setObject(currentUser.email, forKey: "USER_EMAIL")
            userDict.setObject(currentUser.password, forKey: "USER_PASSWORD")
            userDict.setObject(currentUser.accounts.count, forKey: "USER_ACCOUNTS")

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

            let currentUserDict = userDefaults.objectForKey("USER")
            currentUserDict?.addEntriesFromDictionary(accountDict as [NSObject : AnyObject])

            userDefaults.removeObjectForKey("USER")
            userDefaults.setObject(currentUserDict, forKey: "USER")
            userDefaults.synchronize()
        }

    }

    func saveAccountForUserAndIndex(user: User, index: Int) -> NSMutableDictionary! {

        let userDict: NSMutableDictionary = NSMutableDictionary()

        let currentAccount: Account = user.accounts[index] as! Account

        let currentAccountUsername: String = "USER_ACCOUNT_USERNAME_"
        userDict.setObject(currentAccount.username, forKey: currentAccountUsername + String(index))

        let currentAccountPassword: String = "USER_ACCOUNT_PASSWORD_"
        userDict.setObject(currentAccount.password, forKey: currentAccountPassword + String(index))

        let currentAccountUrl: String = "USER_ACCOUNT_URL_"
        userDict.setObject(currentAccount.url, forKey: currentAccountUrl + String(index))

        return userDict
    }
}
