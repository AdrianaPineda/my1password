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
        
        return true
    }
}
