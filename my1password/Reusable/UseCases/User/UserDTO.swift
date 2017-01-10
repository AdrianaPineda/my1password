//
//  UserDTO.swift
//  my1password
//
//  Created by Adriana Pineda on 1/9/17.
//  Copyright © 2017 Adriana Pineda. All rights reserved.
//

import UIKit

class UserDTO {

    fileprivate var id: Int?
    fileprivate let username: String
    fileprivate let password: String

    init(withId id: Int, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }

    init(withUsername username: String, password: String) {
        self.username = username
        self.password = password
    }

    func getId() -> Int? {
        return id
    }
    func getUsername() -> String {
        return username
    }

    func getPassword() -> String {
        return password
    }
}
