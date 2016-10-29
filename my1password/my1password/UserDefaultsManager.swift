//
//  UserDefaultsManager.swift
//  my1password
//
//  Created by Adriana Pineda on 3/23/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

private let sharedInstance = UserDefaultsManager()

class UserDefaultsManager: NSObject {

    //TODO check if userdefaults is initialized every time
    var userDefaults: UserDefaults = UserDefaults.standard
    
    class var userDefaults: UserDefaultsManager {
        return sharedInstance
    }
    
    func setObject(_ value: AnyObject?, forKey key: NSString) {
        
        userDefaults.set(value, forKey: key as String)
        userDefaults.synchronize()
    }
    
    func getObjectForKey(_ key: NSString) -> AnyObject? {
        
        if let currentObject: AnyObject = userDefaults.object(forKey: key as String) as AnyObject? {
            return currentObject
        } else {
            return nil
        }
    }
}
