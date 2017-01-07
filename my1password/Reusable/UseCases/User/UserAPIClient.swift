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

    fileprivate let apiServerUrl = "www.localhost.com:8080"
    fileprivate let usersEndpoint = "%@/users"

    func addUser(user: User,  handler: @escaping ((Int?) -> (Void))) {

        let createUserUrl = String(format: usersEndpoint, apiServerUrl)

        var request: HTTP

        do {

            request = try HTTP.POST(createUserUrl)

        } catch {
            print("Error creating GET request")
            handler(nil)
            return
        }

        request.start { response in
            if let err = response.error {
                print("Error \(err.localizedDescription)")
                handler(nil)
                return
            }

            let responseData = response.data

            do {

                if let responseAsDictionary = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [String: Any] {

                    if let userId: Int = responseAsDictionary["user_id"] as? Int {
                        handler(userId)
                    }
                }

            } catch {
                print("Error parsing response to dictionary")
            }

            handler(nil)
            return
        }
    }

}
