//
//  AddAccountTableViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 5/10/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

class AddAccountTableViewController: UITableViewController {

    weak var delegate: ReloadTableViewDelegate?

    enum AccountFields: Int {
        case Username = 0
        case Password = 1
        case URL = 2
    }
    
    // Properties
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var url: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let saveButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveAccount")
        self.navigationItem.rightBarButtonItem = saveButtonItem

        let cancelButtomItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelButtomItem

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.tableView.addGestureRecognizer(gestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 3
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 1
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Keyboard
    func dismissKeyboard() {
        self.tableView.endEditing(true)
    }
    
    // MARK: Save 
    func saveAccount() {

        self.dismissKeyboard()

        if !areAllFieldsComplete() {
            let alert = UIAlertController(title: "Incomplete form", message: "Please fill all fields before saving", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)

        } else {

            let account: Account = Account(username: username.text!, password: password.text!, url: url.text!)

            let userAccountsManager = UserAccountsManager.userAccounts
            let wasAccountAdded = userAccountsManager.addAccount(account)

            if wasAccountAdded {
                let alert = UIAlertController(title: "Account added", message: "Your account was successfully added", preferredStyle: UIAlertControllerStyle.Alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alertAction: UIAlertAction) -> Void in

                    self.delegate?.reloadTable(self)

                }))

                self.presentViewController(alert, animated: true, completion:nil)

            }
        }

    }
    
    func areAllFieldsComplete() -> Bool {
        
        if isUsernameComplete() && isPasswordComplete() && isURLComplete() {
            return true
        }
        
        return false
    }
    
    func isUsernameComplete() -> Bool {
        
        if username.text == nil || username.text == "" {
            return false
        }
        
        return true
    }
    
    func isPasswordComplete() -> Bool {
        
        if password.text == nil || password.text == "" {
            return false
        }
        
        return true
    }

    func isURLComplete() -> Bool {
        
        if url.text == nil || url.text == "" {
            return false
        }
        
        return true
    }

    // MARK: - Cancel action
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
