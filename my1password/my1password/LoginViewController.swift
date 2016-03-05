//
//  LoginViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 2/16/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    @IBAction func login(sender: AnyObject) {

        if self.areFieldsValid() {
            UserAccountsManager.userAccounts.loadUserAccountsFromConfig()
        } else {

            let alertController: UIAlertController = UIAlertController(title: "Invalid email/password", message: "Your email and/or password are invalids", preferredStyle: UIAlertControllerStyle.Alert)

            let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)

            alertController.addAction(alertAction)

            self.presentViewController(alertController, animated: false, completion: nil)
        }

    }

    func areFieldsValid() -> Bool {

        return self.isPasswordValid() && self.isEmailValid()

    }

    func isPasswordValid() -> Bool {

        if password.text != "" {
            return true
        }

        return false
    }

    func isEmailValid() -> Bool {

        if email.text != "" {
            return true
        }

        return false
    }

}
