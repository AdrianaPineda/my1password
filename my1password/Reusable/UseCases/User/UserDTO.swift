//
//  UserDTO.swift
//  my1password
//
//  Created by Adriana Pineda on 1/9/17.
//  Copyright © 2017 Adriana Pineda. All rights reserved.
//

import UIKit

class UserDTO {

    fileprivate let username: String
    fileprivate let password: String

    init(withUsername username: String, password: String) {
        self.username = username
        self.password = password
    }

    func getUsername() -> String {
        return username
    }

    func getPassword() -> String {
        return password
    }
}
