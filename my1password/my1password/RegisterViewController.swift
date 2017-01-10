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
    fileprivate let emailInvalidAlertTitle: String = "Invalid email"
    fileprivate let emailInvalidAlertMessage: String = "Your email is invalid"
    fileprivate let okAlertActionTitle: String = "OK"
    fileprivate let reenterPasswordText: String = "Re-enter password"
    fileprivate let toUserHomeSegueId: String = "showHomeView"
    fileprivate let errorAlertTitle: String = "Error"
    fileprivate let passwordsDontMatchAlertMessage: String = "Passwords don't match"
    fileprivate let invalidPasswordAlertMessage: String = "Invalid password"

    // MARK: - Outlets
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var verificationCode: UITextField!
    
    @IBOutlet weak var verifyCode: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var sendVerificationCode: UIButton!
    
    @IBOutlet weak var masterPassword: UITextField!
    @IBOutlet weak var savePassword: UIButton!

    // MARK: - Properties
    fileprivate var currentEmail:String = ""
    fileprivate var currentMasterPassword: String = ""
    fileprivate var currentStep: RegistrationStep = RegistrationStep.firstPassword

    fileprivate let userUseCase: UserUseCase = UserUseCase()

    fileprivate enum RegistrationStep {
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
    fileprivate func configureUI() {

        verificationCode.isHidden = true
        verifyCode.isHidden = true
        sendVerificationCode.isHidden = true
        masterPassword.isHidden = true
        savePassword.isHidden = true

    }

    // MARK: - Register
    @IBAction func registerUser(_ sender: AnyObject) {
        
        if !self.isEmailValid() {
            self.showAlert(forAlertTitle: emailInvalidAlertTitle, alertMessage: emailInvalidAlertMessage, withActionTitle: okAlertActionTitle)
            return
        }

        self.currentEmail = self.userEmail.text!
        self.configureUIForVerificationCode()
    }

    fileprivate func configureUIForVerificationCode() {
        verifyCode.isHidden = false
        verificationCode.isHidden = false
        sendVerificationCode.isHidden = false
        register.isHidden = true
    }

    // MARK: - Verify Code
    @IBAction func verifyCode(_ sender: AnyObject) {

        self.verificationCode.isHidden = true
        self.verifyCode.isHidden = true
        self.sendVerificationCode.isHidden = true
        self.masterPassword.isHidden = false
        self.savePassword.isHidden = false
    }

    // MARK: - Save Password
    @IBAction func savePassword(_ sender: AnyObject) {

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

    fileprivate func configureFirstPasswordEntered() {

        self.currentMasterPassword = self.masterPassword.text!
        self.masterPassword.text = ""
        self.currentStep = RegistrationStep.secondPassword
        self.savePassword.setTitle(reenterPasswordText, for: UIControlState())

    }

    fileprivate func configureUIWhenSecondPassDoesNotMatchFirstOne() {

        self.masterPassword.text = ""
        self.showAlert(forAlertTitle: errorAlertTitle, alertMessage: passwordsDontMatchAlertMessage, withActionTitle: okAlertActionTitle)

    }

    fileprivate func configurePassword() {

        // TODO > Loading indicator

        userUseCase.saveUser(username: self.currentEmail, password: self.currentMasterPassword) {
            [weak self] (success) -> (Void) in

            guard success else {
                return
            }

            self?.currentStep = RegistrationStep.finish

            if let toUserHomeSegueId = self?.toUserHomeSegueId {
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: toUserHomeSegueId, sender: self)
                }

            }

        }

    }

    // MARK: - Validate fields
    fileprivate func isEmailValid() -> Bool {
        if (self.userEmail.text ?? "").isEmpty {
            return false
        }
        return true
    }

    fileprivate func isPasswordValid() -> Bool {
        if (self.masterPassword.text ?? "").isEmpty {
            return false
        }

        return true
    }

    // MARK: - Alert
    fileprivate func showAlert(forAlertTitle alertTitle: String, alertMessage: String, withActionTitle actionTitle: String) {

        let alertController: UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)

        let okAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil)

        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)

    }

    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyBoard()
    }
    
    fileprivate func hideKeyBoard() -> Void {
        self.userEmail.resignFirstResponder()
        self.verificationCode.resignFirstResponder()
    }
}
