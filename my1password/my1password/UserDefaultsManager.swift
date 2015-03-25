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

    //TODO check if userdefaults is initialize every time
    var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    class var userDefaults: UserDefaultsManager {
        return sharedInstance
    }
    
    func setObject(value: AnyObject?, forKey key: NSString) {
        
        userDefaults.setObject(value, forKey: key)
        userDefaults.synchronize()
    }
    
    func getObjectForKey(key: NSString) -> AnyObject? {
        
        if let currentObject: AnyObject = userDefaults.objectForKey(key) as AnyObject? {
            return currentObject
        } else {
            return nil
        }
    }
}
