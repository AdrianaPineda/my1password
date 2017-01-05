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

    fileprivate let apiServerUrl = "www.localhost.com"
    fileprivate let accountsEndpoint = "%@/users/%@/accounts"

    func getAccounts(forUser userId: String, handler: @escaping ((Response?) -> (Void))) {

        let getAccountsUrl = String(format: accountsEndpoint, apiServerUrl, userId)

        do {

            let request = try HTTP.GET(getAccountsUrl)
            request.start { response in

                if let err = response.error {
                    print("Error \(err.localizedDescription)")
                    handler(nil)
                    return
                }

                handler(response)

            }

        } catch {
            handler(nil)
            return
        }
    }
}
