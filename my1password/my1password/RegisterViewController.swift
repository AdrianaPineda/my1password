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
        verifyCode.hidden = false
        verificationCode.hidden = false
        sendVerificationCode.hidden = false
        register.hidden = true
    }
    
    @IBAction func verifyCode(sender: AnyObject) {
    }
    
    @IBAction func back(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
