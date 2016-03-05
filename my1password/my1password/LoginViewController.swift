//
//  LoginViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 2/16/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit
import SSKeychain

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

        self.hideKeyBoard()

        if self.areFieldsValid() {

            UserAccountsManager.userAccounts.loadUserAccountsFromConfig()

        } else {

            self.resetFields()

            let alertController: UIAlertController = UIAlertController(title: "Invalid email/password", message: "Your email and/or password are invalid", preferredStyle: UIAlertControllerStyle.Alert)

            let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)

            alertController.addAction(alertAction)

            self.presentViewController(alertController, animated: true, completion: nil)
        }

    }

    func resetFields() {

        self.email.text = ""
        self.password.text = ""
    }

    func areFieldsValid() -> Bool {

        if self.isEmailValid() {

            if !self.isPasswordEmpty() {

                let savedPassword: String? = SSKeychain.passwordForService("com.adrianapineda", account: self.email.text)

                if savedPassword != nil && self.password.text == savedPassword {

                    return true
                }

            }

        }

        return false

    }

    func isPasswordEmpty() -> Bool {

        if password.text != "" {
            return false
        }

        return true

    }

    func isEmailValid() -> Bool {

        if email.text != "" {
            return true
        }

        return false
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if self.areFieldsValid() {
            return true
        }

        return false
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.hideKeyBoard()
    }

    func hideKeyBoard() -> Void {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
    }

}
