//
//  AccountsAPI.swift
//  my1password
//
//  Created by Adriana Pineda on 10/29/16.
//  Copyright © 2016 Adriana Pineda. All rights reserved.
//

import UIKit
import SwiftHTTP

class AccountsAPI: NSObject {

    fileprivate let apiServerUrl = "www.localhost.com:8080"
    fileprivate let accountsEndpoint = "%@/users/%@/accounts"

    // MARK: - GET
    func getAccountsFromDictionary(dict: [String: Any]) -> [Account] {

        return []
    }

    func getAccounts(forUser userId: String, handler: @escaping (([Account]?) -> (Void))) {

        let getAccountsUrl = String(format: accountsEndpoint, apiServerUrl, userId)

        var request: HTTP

        do {

            request = try HTTP.GET(getAccountsUrl)

        } catch {
            print("Error creating GET request")
            handler(nil)
            return
        }

        request.start { [unowned self] response in
            if let err = response.error {
                print("Error \(err.localizedDescription)")
                handler(nil)
                return
            }

            let responseData = response.data

            do {

                if let responseAsDictionary = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [String: Any] {

                    let accounts = self.getAccountsFromDictionary(dict: responseAsDictionary)
                    handler(accounts)
                    return
                }

            } catch {
                print("Error parsing response to dictionary")
            }

            handler(nil)
            return
        }
    }

    // MARK: - ADD
    func addAccount() {

    }
}
