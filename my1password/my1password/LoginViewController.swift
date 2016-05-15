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

    // Constants
    private let loginSegueIdentifier: String = "login"
    private let registerSegueIdentifier: String = "register"

    private let invalidPasswordAlertTitle: String = "Invalid password"
    private let invalidPasswordAlertMessage: String = "Your master password is invalid"
    private let okAlertActionTitle: String = "OK"

    // Properties
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()

        self.configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Configure UI
    private func configureUI() {
        self.password.becomeFirstResponder()
    }

    // MARK: - Login
    @IBAction func login(sender: AnyObject) {

        self.configureUIWhenLoginClicked()

        // Validate fields
        if !self.areFieldsValid() {
            self.showIvalidPasswordAlert()
            return
        }

        // Login user
        self.performLogin()

    }

    private func configureUIWhenLoginClicked() {
        self.hideKeyBoard()
        self.resetFields()
    }

    private func performLogin() {

        UserAccountsManager.userAccounts.loadUserAccountsFromConfig()
        self.performSegueWithIdentifier(loginSegueIdentifier, sender: self)
    }

    // MARK: Reset fields
    private func resetFields() {

        self.password.text = ""
    }

    // MARK: Validate fields
    private func areFieldsValid() -> Bool {

        if self.isPasswordEmpty(){
            return false
        }

        let userAccountsManager: UserAccountsManager = UserAccountsManager.userAccounts
        return userAccountsManager.isMasterPasswordValid(forPassword: self.password.text!)

    }

    private func isPasswordEmpty() -> Bool {

        if password.text == "" {
            return true
        }

        return false

    }

    // MARK: - Keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.hideKeyBoard()
    }

    private func hideKeyBoard() -> Void {
        self.password.resignFirstResponder()
    }

    // MARK: - Alert
    private func showIvalidPasswordAlert() {

        let alertController: UIAlertController = UIAlertController(title: invalidPasswordAlertTitle, message: invalidPasswordAlertMessage, preferredStyle: UIAlertControllerStyle.Alert)

        let alertAction: UIAlertAction = UIAlertAction(title: okAlertActionTitle, style: UIAlertActionStyle.Default, handler: nil)

        alertController.addAction(alertAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
