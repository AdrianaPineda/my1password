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

    let loginSegueIdentifier: String = "login"
    let registerSegueIdentifier: String = "register"

    let invalidPasswordAlertTitle: String = "Invalid password"
    let invalidPasswordAlertMessage: String = "Your master password is invalid"
    let okAlertActionTitle: String = "OK"

    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.password.becomeFirstResponder()
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

            self.resetFields()

            UserAccountsManager.userAccounts.loadUserAccountsFromConfig()
            self.performSegueWithIdentifier(loginSegueIdentifier, sender: self)

        } else {

            self.resetFields()

            let alertController: UIAlertController = UIAlertController(title: invalidPasswordAlertTitle, message: invalidPasswordAlertMessage, preferredStyle: UIAlertControllerStyle.Alert)

            let alertAction: UIAlertAction = UIAlertAction(title: okAlertActionTitle, style: UIAlertActionStyle.Default, handler: nil)

            alertController.addAction(alertAction)

            self.presentViewController(alertController, animated: true, completion: nil)
        }

    }

    func resetFields() {

        self.password.text = ""
    }

    func areFieldsValid() -> Bool {

        if !self.isPasswordEmpty(){

            let userAccountsManager: UserAccountsManager = UserAccountsManager.userAccounts
            return userAccountsManager.isMasterPasswordValid(forPassword: self.password.text!)

        }

        return false

    }

    func isPasswordEmpty() -> Bool {

        if password.text == "" {
            return true
        }

        return false

    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.hideKeyBoard()
    }

    func hideKeyBoard() -> Void {
        self.password.resignFirstResponder()
    }

}
