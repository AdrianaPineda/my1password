//
//  RegisterViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 2/16/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var verificationCode: UITextField!
    
    @IBOutlet weak var verifyCode: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var sendVerificationCode: UIButton!
    
    @IBOutlet weak var masterPassword: UITextField!
    @IBOutlet weak var savePassword: UIButton!
    @IBOutlet weak var back: UIButton!

    let emailInvalidAlertTitle: String = "Invalid email"
    let emailInvalidAlertMessage: String = "Your email is invalid"
    let okAlertActionTitle: String = "OK"
    let reenterPasswordText: String = "Re-enter password"
    let toUserHomeSegueId: String = "showHomeView"
    let errorAlertTitle: String = "Error"
    let passwordsDontMatchAlertMessage: String = "Passwords don't match"
    let invalidPasswordAlertMessage: String = "Invalid password"
    
    var currentEmail:String = ""
    var currentMasterPassword: String = ""
    var currentStep: RegistrationStep = RegistrationStep.firstPassword

    enum RegistrationStep {
        case firstPassword
        case secondPassword
        case finish
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        verificationCode.hidden = true
        verifyCode.hidden = true
        sendVerificationCode.hidden = true
        masterPassword.hidden = true
        savePassword.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func registerUser(sender: AnyObject) {
        
        if self.isEmailValid() {
            self.currentEmail = self.userEmail.text!
            
            verifyCode.hidden = false
            verificationCode.hidden = false
            sendVerificationCode.hidden = false
            register.hidden = true
            
        } else {
            self.showAlert(forAlertTitle: emailInvalidAlertTitle, alertMessage: emailInvalidAlertMessage, withActionTitle: okAlertActionTitle)
        }
    }
    
    func isEmailValid() -> Bool {
        if (self.userEmail.text ?? "").isEmpty {
            return false
        }
        return true
    }
    
    @IBAction func verifyCode(sender: AnyObject) {

        self.verificationCode.hidden = true
        self.verifyCode.hidden = true
        self.sendVerificationCode.hidden = true
        self.masterPassword.hidden = false
        self.savePassword.hidden = false
    }

    @IBAction func savePassword(sender: AnyObject) {

        if isPasswordValid() {

            if self.currentStep == RegistrationStep.firstPassword {

                self.currentMasterPassword = self.masterPassword.text!
                self.configureView(forRegistrationStep: self.currentStep)

            } else {

                let secondPass: String = self.masterPassword.text!

                if secondPass == self.currentMasterPassword {

                    self.configureView(forRegistrationStep: self.currentStep)

                } else {

                    self.masterPassword.text = ""
                    self.showAlert(forAlertTitle: errorAlertTitle, alertMessage: passwordsDontMatchAlertMessage, withActionTitle: okAlertActionTitle)

                }
            }

        } else {
            self.showAlert(forAlertTitle: errorAlertTitle, alertMessage: invalidPasswordAlertMessage, withActionTitle: okAlertActionTitle)
        }
    }

    func configureView(forRegistrationStep registrationStep:RegistrationStep) {

        if registrationStep == RegistrationStep.firstPassword {

            self.masterPassword.text = ""
            self.currentStep = RegistrationStep.secondPassword
            self.savePassword.setTitle(reenterPasswordText, forState: UIControlState.Normal)

        } else if registrationStep == RegistrationStep.secondPassword {

            self.currentStep = RegistrationStep.finish
            self.performSegueWithIdentifier(toUserHomeSegueId, sender: self)
        }
    }

    func showAlert(forAlertTitle alertTitle: String, alertMessage: String, withActionTitle actionTitle: String) {

        let alertController: UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)

        self.presentViewController(alertController, animated: true, completion: nil)

    }

    func isPasswordValid() -> Bool {
        if (self.masterPassword.text ?? "").isEmpty {
            return false
        }

        return true
    }
    
    @IBAction func back(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.hideKeyBoard()
    }
    
    func hideKeyBoard() -> Void {
        self.userEmail.resignFirstResponder()
        self.verificationCode.resignFirstResponder()
    }
}
