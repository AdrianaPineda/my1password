//
//  Account.swift
//  my1password
//
//  Created by Adriana Pineda on 3/23/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import Foundation

class Account: NSObject {

    private var username: String = ""
    private var password: String = ""
    private var url: String = ""

    init(username:String, password:String, url:String) {
        self.username = username
        self.password = password
        self.url = url
    }

    func getUsername() -> String {
        return username
    }

    func getPassword() -> String {
        return password
    }

    func getUrl() -> String {
        return url
    }

    func setUsername(username: String) {
        self.username = username
    }

    func setPassword(password: String) {
        self.password = password
    }

    func setUrl(url: String) {
        self.url = url
    }

}