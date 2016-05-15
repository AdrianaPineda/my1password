//
//  User.swift
//  my1password
//
//  Created by Adriana Pineda on 3/23/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import Foundation

class User: NSObject {
    
    private var email: String = ""
    private var password: String = ""
    private var accounts: [Account] = []
    
    init(email: String, password: String, accounts: [Account]) {
        
        self.email = email
        self.password = password
        self.accounts = accounts
        
    }

    init(email: String, password: String) {

        self.email = email
        self.password = password

    }

    func getEmail() -> String {
        return self.email
    }

    func getPassword() -> String {
        return self.password
    }

    func getAccounts() -> [Account] {
        return self.accounts
    }

    func addAccount(withUsername username: String, password: String, url: String) {
        let numberOfAccounts = self.accounts.count
        let newAccount = Account(username: username, password: password, url: url, id: numberOfAccounts)

        self.accounts.append(newAccount)
    }

    func addAccount(account: Account) -> Bool {
        
        self.accounts.append(account)
        
        return true
    }

    func updateAccount(account: Account, forAccountId accountId: Int) -> Bool {

        if self.accounts.count > accountId {

            self.accounts[accountId] = account;
            return true

        }

        return false
    }

    static func isUserValid(user: User?) -> Bool {

        if user == nil {
            return false
        }

        if (user!.email ?? "").isEmpty || (user!.password ?? "").isEmpty || user!.accounts.count < 0 {
            return false
        } else {
            return true
        }

    }
}