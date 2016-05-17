//
//  AccountTabBarController.swift
//  my1password
//
//  Created by Adriana Pineda on 2/16/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

class UserHomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func barButtonItemClicked () -> Void {
        
    }
    
    func signOut () -> Void {
        
    }

}
