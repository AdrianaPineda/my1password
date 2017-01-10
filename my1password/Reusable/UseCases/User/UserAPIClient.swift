//
//  UserAPIClient.swift
//  my1password
//
//  Created by Adriana Pineda on 1/7/17.
//  Copyright © 2017 Adriana Pineda. All rights reserved.
//

import UIKit
import SwiftHTTP

class UserAPIClient: NSObject {

    fileprivate let apiServerUrl = "http://localhost:8080"
    fileprivate let usersEndpoint = "%@/users"

    func addUser(username: String, password: String, handler: @escaping ((Int?) -> (Void))) {

        let createUserUrl = String(format: usersEndpoint, apiServerUrl)

        var request: HTTP

        do {

            let params = ["username": username, "password": password]
            request = try HTTP.POST(createUserUrl, parameters: params, requestSerializer: JSONParameterSerializer())

        } catch {
            print("Error creating POST request")
            handler(nil)
            return
        }

        request.start { response in
            if let err = response.error {
                print("Error \(err.description)")
                handler(nil)
                return
            }

            let responseData = response.data

            do {

                if let responseAsDictionary = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [String: Any] {

                    guard let user: [String: Any] = responseAsDictionary["user"] as? [String: Any]  else {
                        handler(nil)
                        return
                    }

                    if let userId = user["id"] as? Int {
                        handler(userId)
                        return
                    }
                }

            } catch {
                print("Error parsing response to dictionary")
                handler(nil)
            }

            return
        }
    }

}
