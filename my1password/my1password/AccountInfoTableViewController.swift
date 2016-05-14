//
//  AccountInfoTableViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 5/10/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

class AccountInfoTableViewController: UITableViewController {

    // Constants
    let cancelButtonTitle: String = "Cancel"
    let saveButtonTitle: String = "Save"
    let editButtonTitle: String = "Edit"
    let viewEditNavigationTitle: String = "Edit"
    let incompleteFormTitle: String = "Incomplete form"
    let incompleteFormMessage: String = "Please fill all fields before saving"
    let okAction: String = "OK"
    let accountUpdatedAlertTitle: String = "Account updated"
    let accountUpdatedAlertMessage: String = "Your account was successfully updated"
    let accountAddedAlertTitle = "Account added"
    let accountAddedAlertMessage = "Your account was successfully added"
    let revealMenuItemText = "Reveal"

    let copySelector: Selector = #selector(NSObject.copy(_:))
    let revealSelector: Selector = "reveal:"
    let saveAccountAction: Selector = #selector(AccountInfoTableViewController.saveAccount)
    let cancelAction: Selector = #selector(AccountInfoTableViewController.cancel)
    let editAction: Selector = #selector(AccountInfoTableViewController.edit)
    let dismissKeyboardAction: Selector = #selector(AccountInfoTableViewController.dismissKeyboard)

    enum ViewType {
        case Add, Edit
    }

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

    var viewType: ViewType = .Add

    var currentAccount: Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let cancelButtomItem = UIBarButtonItem(title: cancelButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: cancelAction)

        self.navigationItem.leftBarButtonItem = cancelButtomItem

        if self.viewType == .Add {

            let saveButtonItem = UIBarButtonItem(title: saveButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: saveAccountAction)
            self.navigationItem.rightBarButtonItem = saveButtonItem

            self.username.becomeFirstResponder()

        } else {

            self.navigationItem.title = viewEditNavigationTitle
            let editButtonItem = UIBarButtonItem(title: editButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: editAction)
            self.navigationItem.rightBarButtonItem = editButtonItem

            self.configureSavedTexts()
        }

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: dismissKeyboardAction)
        self.tableView.addGestureRecognizer(gestureRecognizer)

        let testMenuItem: UIMenuItem = UIMenuItem(title: revealMenuItemText, action: revealSelector)
        UIMenuController.sharedMenuController().menuItems = [testMenuItem]
        UIMenuController.sharedMenuController().update()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    override func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {

        if action == copySelector || action == revealSelector {
            return true
        }
        return false
    }

    override func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {

        // Required for custom actions
    }

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

    // MARK: - Edit
    func edit() {

        self.username.enabled = true
        self.password.enabled = true
        self.url.enabled = true

        self.username.becomeFirstResponder()

        let saveButtonItem = UIBarButtonItem(title: saveButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: saveAccountAction)
        self.navigationItem.rightBarButtonItem = saveButtonItem
    }

    func configureSavedTexts() {

        self.username.enabled = false
        self.password.enabled = false
        self.url.enabled = false

        if self.areFieldsValid() {
            self.username.text = self.currentAccount?.getUsername()
            self.password.text = self.currentAccount?.getPassword()
            self.url.text = self.currentAccount?.getUrl()

        }
    }

    func areFieldsValid() -> Bool {
        if self.currentAccount != nil {
            if (self.currentAccount?.getUsername() ?? "").isEmpty || (self.currentAccount?.getPassword() ?? "").isEmpty || (self.currentAccount?.getUrl() ?? "").isEmpty {
                return false
            }
        }

        return true
    }
    
    // MARK: Keyboard
    func dismissKeyboard() {
        self.tableView.endEditing(true)
    }
    
    // MARK: Save 
    func saveAccount() {

        self.dismissKeyboard()

        if !areAllFieldsComplete() {
            let alert = UIAlertController(title: incompleteFormTitle, message: incompleteFormMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: okAction, style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)

        } else {

            let userAccountsManager = UserAccountsManager.userAccounts
            var alertTitle: String = ""
            var alertMessage: String = ""
            var wasActionSuccesful: Bool = false

            if self.viewType == .Add {

                let account: Account = Account(username: username.text!, password: password.text!, url: url.text!)
                wasActionSuccesful = userAccountsManager.addAccount(account)

                alertTitle = accountAddedAlertTitle
                alertMessage = accountAddedAlertMessage

            } else {

                self.currentAccount?.setUsername(self.username.text!)
                self.currentAccount?.setPassword(self.password.text!)
                self.currentAccount?.setUrl(self.url.text!)

                wasActionSuccesful = userAccountsManager.updateAccount(self.currentAccount!)

                alertTitle = accountUpdatedAlertTitle
                alertMessage = accountUpdatedAlertMessage
            }

            if wasActionSuccesful {
                let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)

                alert.addAction(UIAlertAction(title: okAction, style: UIAlertActionStyle.Default, handler: {(alertAction: UIAlertAction) -> Void in

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
        if self.viewType == .Add {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
