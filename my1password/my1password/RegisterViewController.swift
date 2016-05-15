//
//  RegisterViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 2/16/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - Constants
    private let emailInvalidAlertTitle: String = "Invalid email"
    private let emailInvalidAlertMessage: String = "Your email is invalid"
    private let okAlertActionTitle: String = "OK"
    private let reenterPasswordText: String = "Re-enter password"
    private let toUserHomeSegueId: String = "showHomeView"
    private let errorAlertTitle: String = "Error"
    private let passwordsDontMatchAlertMessage: String = "Passwords don't match"
    private let invalidPasswordAlertMessage: String = "Invalid password"

    // MARK: - Outlets
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var verificationCode: UITextField!
    
    @IBOutlet weak var verifyCode: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var sendVerificationCode: UIButton!
    
    @IBOutlet weak var masterPassword: UITextField!
    @IBOutlet weak var savePassword: UIButton!

    // MARK: - Properties
    private var currentEmail:String = ""
    private var currentMasterPassword: String = ""
    private var currentStep: RegistrationStep = RegistrationStep.firstPassword

    private enum RegistrationStep {
        case firstPassword
        case secondPassword
        case finish
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Configure UI for first time
    private func configureUI() {

        verificationCode.hidden = true
        verifyCode.hidden = true
        sendVerificationCode.hidden = true
        masterPassword.hidden = true
        savePassword.hidden = true

    }

    // MARK: - Register
    @IBAction func registerUser(sender: AnyObject) {
        
        if !self.isEmailValid() {
            self.showAlert(forAlertTitle: emailInvalidAlertTitle, alertMessage: emailInvalidAlertMessage, withActionTitle: okAlertActionTitle)
            return
        }

        self.currentEmail = self.userEmail.text!
        self.configureUIForVerificationCode()
    }

    private func configureUIForVerificationCode() {
        verifyCode.hidden = false
        verificationCode.hidden = false
        sendVerificationCode.hidden = false
        register.hidden = true
    }

    // MARK: - Verify Code
    @IBAction func verifyCode(sender: AnyObject) {

        self.verificationCode.hidden = true
        self.verifyCode.hidden = true
        self.sendVerificationCode.hidden = true
        self.masterPassword.hidden = false
        self.savePassword.hidden = false
    }

    // MARK: - Save Password
    @IBAction func savePassword(sender: AnyObject) {

        if !isPasswordValid() {
            self.showAlert(forAlertTitle: errorAlertTitle, alertMessage: invalidPasswordAlertMessage, withActionTitle: okAlertActionTitle)
            return
        }

        if self.currentStep == RegistrationStep.firstPassword {
            self.configureFirstPasswordEntered()
            return
        }

        if self.masterPassword.text! != self.currentMasterPassword {
            self.configureUIWhenSecondPassDoesNotMatchFirstOne()
            return
        }

        self.configurePassword()

    }

    private func configureFirstPasswordEntered() {

        self.currentMasterPassword = self.masterPassword.text!
        self.masterPassword.text = ""
        self.currentStep = RegistrationStep.secondPassword
        self.savePassword.setTitle(reenterPasswordText, forState: UIControlState.Normal)

    }

    private func configureUIWhenSecondPassDoesNotMatchFirstOne() {

        self.masterPassword.text = ""
        self.showAlert(forAlertTitle: errorAlertTitle, alertMessage: passwordsDontMatchAlertMessage, withActionTitle: okAlertActionTitle)

    }

    private func configurePassword() {

        UserAccountsManager.userAccounts.configureUser(withEmail: self.currentEmail, andPassword: self.currentMasterPassword)
        self.currentStep = RegistrationStep.finish
        self.performSegueWithIdentifier(toUserHomeSegueId, sender: self)

    }

    // MARK: - Validate fields
    private func isEmailValid() -> Bool {
        if (self.userEmail.text ?? "").isEmpty {
            return false
        }
        return true
    }

    private func isPasswordValid() -> Bool {
        if (self.masterPassword.text ?? "").isEmpty {
            return false
        }

        return true
    }

    // MARK: - Alert
    private func showAlert(forAlertTitle alertTitle: String, alertMessage: String, withActionTitle actionTitle: String) {

        let alertController: UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)

        let okAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil)

        alertController.addAction(okAction)

        self.presentViewController(alertController, animated: true, completion: nil)

    }

    // MARK: - Keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.hideKeyBoard()
    }
    
    private func hideKeyBoard() -> Void {
        self.userEmail.resignFirstResponder()
        self.verificationCode.resignFirstResponder()
    }
}
