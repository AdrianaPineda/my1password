//
//  AddAccountViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 3/23/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var url: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Add getsure recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        
        //Move view up and down when textfield is selected
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func isUsernameFilled() -> Bool {
        
        if username.text == "" {
            return false
        }
        
        return true
    }
    
    func isPasswordFilled() -> Bool {
        
        if password.text == "" {
            return false
        }
        
        return true
    }
    
    func isURLFilled() -> Bool {
        
        if url.text == "" {
            return false
        }
        
        return true
    }
    
    func allFieldsAreFilled() -> Bool {
        
        if isUsernameFilled() && isPasswordFilled() && isURLFilled() {
            return true
        }
        
        return false
    }
    
    @IBAction func saveAccount(sender: AnyObject) {
        
        if allFieldsAreFilled() {
            
        } else {
            
            let alertController = UIAlertController(title: "Empty fields", message: "Please fill all the fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    //MARK: - Keyboard
    func dismissKeyboard() -> Void {
        username.resignFirstResponder()
        password.resignFirstResponder()
        url.resignFirstResponder()
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 50
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 50
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
