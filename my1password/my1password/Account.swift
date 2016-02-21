//
//  Account.swift
//  my1password
//
//  Created by Adriana Pineda on 3/23/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import Foundation

class Account: NSObject {

    var username: String = ""
    var password: String = ""
    var url: String = ""

    init(username:String, password:String, url:String) {
        self.username = username
        self.password = password
        self.url = url
    }

}