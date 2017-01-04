//
//  LoginViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 2/16/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Constants
    fileprivate let loginSegueIdentifier: String = "login"
    fileprivate let registerSegueIdentifier: String = "register"

    fileprivate let invalidPasswordAlertTitle: String = "Invalid password"
    fileprivate let invalidPasswordAlertMessage: String = "Your master password is invalid"
    fileprivate let okAlertActionTitle: String = "OK"

    // MARK: - Properties
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    // MARK: - Lifecycle
    override func viewDidLoad() {

        super.viewDidLoad()
        self.configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Configure UI
    fileprivate func configureUI() {
        self.username.becomeFirstResponder()
    }

    // MARK: - Login
    @IBAction func login(_ sender: AnyObject) {

        self.hideKeyBoard()

        // Validate fields
        if !self.areFieldsValid() {
            self.resetFields()
            self.showIvalidPasswordAlert()
            return
        }

        // Login user
        self.performLogin()

    }

    fileprivate func performLogin() {

        self.resetFields()
        self.performSegue(withIdentifier: loginSegueIdentifier, sender: self)
    }

    // MARK: Reset fields
    fileprivate func resetFields() {

        self.password.text = ""
    }

    // MARK: Validate fields
    fileprivate func areFieldsValid() -> Bool {

        guard isUsernameValid() && isPasswordValid() else {
            return false
        }

        let passwordValid = UserUseCase().isMasterPasswordValid(password: self.password.text!, forUser: username.text!)
        return passwordValid

    }

    fileprivate func isUsernameValid() -> Bool {

        guard let currentUsernameText = username.text else {
            return false
        }

        if currentUsernameText.isEmpty {
            return false
        }

        return true

    }

    fileprivate func isPasswordValid() -> Bool {

        guard let currentPasswordText = password.text else {
            return false
        }

        if currentPasswordText.isEmpty {
            return false
        }

        return true

    }

    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyBoard()
    }

    fileprivate func hideKeyBoard() -> Void {
        self.username.resignFirstResponder()
        self.password.resignFirstResponder()
    }

    // MARK: - Alert
    fileprivate func showIvalidPasswordAlert() {

        let alertController: UIAlertController = UIAlertController(title: invalidPasswordAlertTitle, message: invalidPasswordAlertMessage, preferredStyle: UIAlertControllerStyle.alert)

        let alertAction: UIAlertAction = UIAlertAction(title: okAlertActionTitle, style: UIAlertActionStyle.default, handler: nil)

        alertController.addAction(alertAction)

        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == loginSegueIdentifier {

            guard let userHomeTabBarController: UserHomeTabBarController = segue.destination as? UserHomeTabBarController else {
                return
            }

            let controllers = userHomeTabBarController.childViewControllers

            for controller in controllers {
                guard let accountsViewController: AccountsTableViewController = controller as? AccountsTableViewController else {
                    continue
                }

                accountsViewController.username = username.text
            }

        }
    }

}
