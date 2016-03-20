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
    
    @IBOutlet weak var back: UIButton!
    
    var currentEmail:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        verificationCode.hidden = true
        verifyCode.hidden = true
        sendVerificationCode.hidden = true
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
            let alertController: UIAlertController = UIAlertController(title: "Invalid email", message: "Your email is invalid", preferredStyle: UIAlertControllerStyle.Alert)
            
            let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alertController.addAction(alertAction)
        }
    }
    
    func isEmailValid() -> Bool {
        if (self.userEmail.text ?? "").isEmpty {
            return false
        }
        
        return true
    }
    
    @IBAction func verifyCode(sender: AnyObject) {
        
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
