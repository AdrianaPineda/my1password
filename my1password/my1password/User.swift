//
//  User.swift
//  my1password
//
//  Created by Adriana Pineda on 3/23/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var email: String = ""
    var password: String = ""
    var accounts: [Account] = []
    
    init(email: String, password: String, accounts: [Account]) {
        
        self.email = email
        self.password = password
        self.accounts = accounts
        
    }

    init(email: String, password: String) {

        self.email = email
        self.password = password

    }
    
    func addAccount(account: Account) -> Bool {
        
        self.accounts.append(account)
        
        return true
    }

    func updateAccount(account: Account) -> Bool {

        if let index: Int = self.accounts.indexOf(account) {

            self.accounts[index] = account
            return true

        }

        return false
    }
}