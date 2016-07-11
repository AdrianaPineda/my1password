//
//  AccountInfoTableViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 5/10/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

class AccountInfoTableViewController: UITableViewController {

    // MARK: - Constants
    private let cancelButtonTitle: String = "Cancel"
    private let saveButtonTitle: String = "Save"
    private let editButtonTitle: String = "Edit"
    private let viewEditNavigationTitle: String = "Edit"
    private let incompleteFormTitle: String = "Incomplete form"
    private let incompleteFormMessage: String = "Please fill all fields before saving"
    private let okAction: String = "OK"
    private let accountUpdatedAlertTitle: String = "Account updated"
    private let accountUpdatedAlertMessage: String = "Your account was successfully updated"
    private let accountAddedAlertTitle = "Account added"
    private let accountAddedAlertMessage = "Your account was successfully added"
    private let revealMenuItemText = "Reveal"

    // MARK: - Selectors
    private let copySelector: Selector = #selector(AccountInfoTableViewCell.copy(_:))
    private let revealSelector: Selector = #selector(AccountInfoTableViewCell.reveal(_:))
    private let saveAction: Selector = #selector(AccountInfoTableViewController.save)
    private let cancelAction: Selector = #selector(AccountInfoTableViewController.cancel)
    private let editAction: Selector = #selector(AccountInfoTableViewController.edit)
    private let dismissKeyboardAction: Selector = #selector(AccountInfoTableViewController.dismissKeyboard)

    // MARK: - Properties

    // Possible View types
    enum ViewType {
        case Add, Edit
    }

    // View Sections for Account Info
    private enum AccountInfoSections: Int {
        case Username
        case Password
        case Url

        static let allValues = [Username, Password, Url]
    }

    weak var delegate: ReloadTableViewDelegate?

    private var viewType: ViewType = .Add

    private let userAccountsManager = UserAccountsManager.userAccounts
    private var currentAccount: Account? = nil

    // MARK: - Outlets
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var url: UITextField!

    // MARK: - Lifecycle
    override func viewDidLoad() {

        super.viewDidLoad()
        self.configureUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - ViewType
    func setViewType(viewType: ViewType) {
        self.viewType = viewType
    }

    func getViewType() -> ViewType {
        return self.viewType
    }

    // MARK: - Current Account
    func setAccount(account: Account) {
        self.currentAccount = account
    }

    // MARK: - Configure UI for first time
    private func configureUI() {

        self.configureLeftButtonItem()
        self.configureRightButtonItem()
        self.configureGestureForKeyboard()
        self.configureFields()
        self.configureMenuItem()

    }

    private func configureLeftButtonItem() {
        let cancelButtomItem = UIBarButtonItem(title: cancelButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: cancelAction)
        self.navigationItem.leftBarButtonItem = cancelButtomItem
    }

    private func configureRightButtonItem() {

        if self.viewType == .Add {
            self.configureRightButtonItemToSave()
        } else {
            self.configureRightButtonItemToEdit()
        }
    }

    private func configureRightButtonItemToSave() {

        let saveButtonItem = UIBarButtonItem(title: saveButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: saveAction)
        self.navigationItem.rightBarButtonItem = saveButtonItem
    }

    private func configureRightButtonItemToEdit() {

        self.navigationItem.title = viewEditNavigationTitle
        let editButtonItem = UIBarButtonItem(title: editButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: editAction)
        self.navigationItem.rightBarButtonItem = editButtonItem

    }

    private func configureMenuItem() {

        let testMenuItem: UIMenuItem = UIMenuItem(title: revealMenuItemText, action: revealSelector)
        UIMenuController.sharedMenuController().menuItems = [testMenuItem]
        UIMenuController.sharedMenuController().update()

    }

    private func configureFields() {

        if self.viewType == .Add {
            self.focusFirstItem()
        } else {
            self.populateAccountInfoFields()
        }

    }

    private func focusFirstItem() {
        self.username.becomeFirstResponder()
    }

    private func populateAccountInfoFields() {

        if !self.areFieldsValid() {
            return
        }

        self.disableFields()

        self.username.text = self.currentAccount?.getUsername()
        self.password.text = self.currentAccount?.getPassword()
        self.url.text = self.currentAccount?.getUrl()
    }

    private func disableFields() {
        self.username.enabled = false
        self.password.enabled = false
        self.url.enabled = false
    }

    private func areFieldsValid() -> Bool {

        if self.currentAccount == nil {
            return false
        }

        if (self.currentAccount?.getUsername() ?? "").isEmpty {
            return false
        }

        if (self.currentAccount?.getPassword() ?? "").isEmpty {
            return false
        }

        if (self.currentAccount?.getUrl() ?? "").isEmpty {
            return false
        }

        return true
    }

    // MARK: Keyboard
    private func configureGestureForKeyboard() {

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: dismissKeyboardAction)
        self.tableView.addGestureRecognizer(gestureRecognizer)

    }

    func dismissKeyboard() {
        self.tableView.endEditing(true)
    }

    // MARK: - Table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return AccountInfoSections.allValues.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    // MARK: - Edit
    func edit() {

        self.configureUIWhenEditing()
    }

    private func configureUIWhenEditing() {

        self.enableEditFields()
        self.configureRightButtonItemToSave()

    }

    private func enableEditFields() {
        self.username.enabled = true
        self.password.enabled = true
        self.url.enabled = true

        self.username.becomeFirstResponder()
    }

    // MARK:- Save Account
    func save() {

        self.dismissKeyboard()

        if !self.validateFieldsWhenSaving() {
            return
        }

        let accountAddedOrUpdated = self.addOrUpdateAccount()

        if accountAddedOrUpdated {
            self.showAccountSavedConfirmationForViewType()
        }

    }

    private func addOrUpdateAccount() -> Bool {

        if self.viewType == .Add {
            return self.addNewAccount()
        }

        return self.updateExistingAccount()
    }

    private func showAccountSavedConfirmationForViewType() {

        if self.viewType == .Add {
            self.showAccountSavedConfirmation(accountAddedAlertTitle, andMessage: accountAddedAlertTitle)

        } else {
            self.showAccountSavedConfirmation(accountUpdatedAlertTitle, andMessage: accountUpdatedAlertMessage)
        }

    }

    private func showAccountSavedConfirmation(alertTitle: String, andMessage alertMessage: String) {

        self.showAlert(withTitle: alertTitle, andMessage: alertMessage, handler: {(alertAction: UIAlertAction) -> Void in

            self.delegate?.reloadTable(self)

        })
    }

    // MARK: Add Account
    private func addNewAccount() -> Bool {

        let usernameText = username.text!
        let passwordText = password.text!
        let urlText = url.text!

        let addSuccessful = userAccountsManager.addAccount(withUsername: usernameText, password: passwordText, url: urlText)

        return addSuccessful
    }

    // MARK: Update Account
    private func updateExistingAccount() -> Bool {

        if self.currentAccount?.getId() == nil {
            return false
        }

        let account = Account(username: self.username.text!, password: self.password.text!, url: self.url.text!, id:(self.currentAccount?.getId())!)

        let updateSuccessful = userAccountsManager.updateAccount(account, forCurrentAccount: currentAccount)
        return updateSuccessful

    }

    // MARK: Alert
    private func showAlert(withTitle alertTitle: String, andMessage alertMessage: String, handler: ((UIAlertAction) -> Void)?) {

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: okAction, style: UIAlertActionStyle.Default, handler: handler))

        self.presentViewController(alert, animated: true, completion:nil)

    }

    // MARK: Fields Validation
    private func validateFieldsWhenSaving() -> Bool{
        let areAllFieldsComplete = self.areAllFieldsComplete()

        if !areAllFieldsComplete {

            self.showAlert(withTitle: incompleteFormTitle, andMessage: incompleteFormMessage, handler: nil)
        }

        return areAllFieldsComplete
    }

    private func areAllFieldsComplete() -> Bool {
        
        if isUsernameComplete() && isPasswordComplete() && isURLComplete() {
            return true
        }
        
        return false
    }
    
    private func isUsernameComplete() -> Bool {
        
        if username.text == nil || username.text == "" {
            return false
        }
        
        return true
    }
    
    private func isPasswordComplete() -> Bool {
        
        if password.text == nil || password.text == "" {
            return false
        }
        
        return true
    }

    private func isURLComplete() -> Bool {
        
        if url.text == nil || url.text == "" {
            return false
        }
        
        return true
    }

    // MARK: - Cancel
    func cancel() {
        if self.viewType == .Add {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
