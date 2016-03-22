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
    
    func addAccount(account: Account) -> Bool {
        
        accounts.append(account)
        
        return true
    }
}