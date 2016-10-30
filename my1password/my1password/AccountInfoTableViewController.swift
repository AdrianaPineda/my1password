//
//  AccountInfoTableViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 5/10/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit
import CoreData

class AccountInfoTableViewController: UITableViewController {

    // MARK: - Constants
    fileprivate let cancelButtonTitle: String = "Cancel"
    fileprivate let saveButtonTitle: String = "Save"
    fileprivate let editButtonTitle: String = "Edit"
    fileprivate let viewEditNavigationTitle: String = "Edit"
    fileprivate let incompleteFormTitle: String = "Incomplete form"
    fileprivate let incompleteFormMessage: String = "Please fill all fields before saving"
    fileprivate let okAction: String = "OK"
    fileprivate let accountUpdatedAlertTitle: String = "Account updated"
    fileprivate let accountUpdatedAlertMessage: String = "Your account was successfully updated"
    fileprivate let accountAddedAlertTitle = "Account added"
    fileprivate let accountAddedAlertMessage = "Your account was successfully added"
    fileprivate let revealMenuItemText = "Reveal"
    fileprivate let concealMenuItemText = "Conceal"

    // MARK: - Selectors
    fileprivate let copySelector: Selector = #selector(UIResponderStandardEditActions.copy(_:))
    fileprivate let revealSelector: Selector = Selector("reveal:")
    fileprivate let concealSelector: Selector = Selector("conceal:")

    fileprivate let saveAction: Selector = #selector(AccountInfoTableViewController.save)
    fileprivate let cancelAction: Selector = #selector(AccountInfoTableViewController.cancel)
    fileprivate let editAction: Selector = #selector(AccountInfoTableViewController.edit)
    fileprivate let dismissKeyboardAction: Selector = #selector(AccountInfoTableViewController.dismissKeyboard)

    // MARK: - Properties
    fileprivate let accountsUseCase = AccountsUseCase()

    // Possible View types
    enum ViewType {
        case add, edit
    }

    // View Sections for Account Info
    fileprivate enum AccountInfoSections: Int {
        case username
        case password
        case url

        static let allValues = [username, password, url]

        func position() -> Int {
            switch self {
            case .username:
                return 0
            case .password:
                return 1
            case .url:
                return 2
            }
        }
    }

    weak var delegate: ReloadTableViewDelegate?

    fileprivate var viewType: ViewType = .add

    fileprivate let userAccountsManager = UserAccountsManager.userAccounts
    fileprivate var currentAccount: NSManagedObject? = nil

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
    func setViewType(_ viewType: ViewType) {
        self.viewType = viewType
    }

    func getViewType() -> ViewType {
        return self.viewType
    }

    // MARK: - Current Account
    func setAccount(_ account: NSManagedObject) {
        self.currentAccount = account
    }

    // MARK: - Configure UI for first time
    fileprivate func configureUI() {

        self.configureLeftButtonItem()
        self.configureRightButtonItem()
        self.configureGestureForKeyboard()
        self.configureFields()
        self.configureMenuItem()

    }

    fileprivate func configureLeftButtonItem() {
        let cancelButtomItem = UIBarButtonItem(title: cancelButtonTitle, style: UIBarButtonItemStyle.plain, target: self, action: cancelAction)
        self.navigationItem.leftBarButtonItem = cancelButtomItem
    }

    fileprivate func configureRightButtonItem() {

        if self.viewType == .add {
            self.configureRightButtonItemToSave()
        } else {
            self.configureRightButtonItemToEdit()
        }
    }

    fileprivate func configureRightButtonItemToSave() {

        let saveButtonItem = UIBarButtonItem(title: saveButtonTitle, style: UIBarButtonItemStyle.plain, target: self, action: saveAction)
        self.navigationItem.rightBarButtonItem = saveButtonItem
    }

    fileprivate func configureRightButtonItemToEdit() {

        self.navigationItem.title = viewEditNavigationTitle
        let editButtonItem = UIBarButtonItem(title: editButtonTitle, style: UIBarButtonItemStyle.plain, target: self, action: editAction)
        self.navigationItem.rightBarButtonItem = editButtonItem

    }

    fileprivate func configureMenuItem() {

        let revealMenuItem: UIMenuItem = UIMenuItem(title: revealMenuItemText, action: revealSelector)
        let concealMenuItem: UIMenuItem = UIMenuItem(title: concealMenuItemText, action: concealSelector)

        UIMenuController.shared.menuItems = [revealMenuItem, concealMenuItem]
        UIMenuController.shared.update()

    }

    fileprivate func configureFields() {

        if self.viewType == .add {
            self.focusFirstItem()
        } else {
            self.populateAccountInfoFields()
        }

    }

    fileprivate func focusFirstItem() {
        self.username.becomeFirstResponder()
    }

    fileprivate func populateAccountInfoFields() {

        if !self.areFieldsValid() {
            return
        }

        self.disableFields()

        self.username.text = self.currentAccount?.value(forKey: "username") as! String?
        self.password.text = self.currentAccount?.value(forKey: "password") as! String?
        self.url.text = self.currentAccount?.value(forKey: "url") as! String?
    }

    fileprivate func disableFields() {
        self.username.isEnabled = false
        self.password.isEnabled = false
        self.url.isEnabled = false
    }

    fileprivate func areFieldsValid() -> Bool {

//        if self.currentAccount == nil {
//            return false
//        }
//
//        if (self.currentAccount?.value(forKey: "username") ?? "").isEmpty {
//            return false
//        }
//
//        if (self.currentAccount?.value(forKey: "password") ?? "").isEmpty {
//            return false
//        }
//
//        if (self.currentAccount?.value(forKey: "url") ?? "").isEmpty {
//            return false
//        }

        return true
    }

    // MARK: Keyboard
    fileprivate func configureGestureForKeyboard() {

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: dismissKeyboardAction)
        self.tableView.addGestureRecognizer(gestureRecognizer)

    }

    func dismissKeyboard() {
        self.tableView.endEditing(true)
    }

    // MARK: - Table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return AccountInfoSections.allValues.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {

        if indexPath.section == AccountInfoSections.password.position() {
            return true
        }

        return false
    }

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {

        if action == copySelector || (action == revealSelector && self.password.isSecureTextEntry) || (action == concealSelector && !self.password.isSecureTextEntry) {
            return true
        }
        return false
    }

    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {

        // Required for custom actions
    }

    // MARK: - Edit
    func edit() {

        self.configureUIWhenEditing()
    }

    fileprivate func configureUIWhenEditing() {

        self.enableEditFields()
        self.configureRightButtonItemToSave()

    }

    fileprivate func enableEditFields() {
        self.username.isEnabled = true
        self.password.isEnabled = true
        self.url.isEnabled = true

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

    fileprivate func addOrUpdateAccount() -> Bool {

        if self.viewType == .add {
            return self.addNewAccount()
        }

        return self.updateExistingAccount()
    }

    fileprivate func showAccountSavedConfirmationForViewType() {

        if self.viewType == .add {
            self.showAccountSavedConfirmation(accountAddedAlertTitle, andMessage: accountAddedAlertTitle)

        } else {
            self.showAccountSavedConfirmation(accountUpdatedAlertTitle, andMessage: accountUpdatedAlertMessage)
        }

    }

    fileprivate func showAccountSavedConfirmation(_ alertTitle: String, andMessage alertMessage: String) {

        self.showAlert(withTitle: alertTitle, andMessage: alertMessage, handler: {(alertAction: UIAlertAction) -> Void in

            self.delegate?.reloadTable(self)

        })
    }

    // MARK: Add Account
    fileprivate func addNewAccount() -> Bool {

        guard let usernameText = username.text else {
            return false
        }

        guard let passwordText = password.text else {
            return false
        }

        guard let urlText = url.text else {
            return false
        }

        return self.accountsUseCase.addAccount(usernameText, password: passwordText, url: urlText)
    }

    // MARK: Update Account
    fileprivate func updateExistingAccount() -> Bool {

        guard let currentAccount = self.currentAccount else {
            return false
        }

        guard let usernameText = username.text else {
            return false
        }
        
        guard let passwordText = password.text else {
            return false
        }
        
        guard let urlText = url.text else {
            return false
        }
        
        return self.accountsUseCase.updateAccount(currentAccount, username: usernameText, password: passwordText, url: urlText)

    }

    // MARK: Alert
    fileprivate func showAlert(withTitle alertTitle: String, andMessage alertMessage: String, handler: ((UIAlertAction) -> Void)?) {

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: okAction, style: UIAlertActionStyle.default, handler: handler))

        self.present(alert, animated: true, completion:nil)

    }

    // MARK: Fields Validation
    fileprivate func validateFieldsWhenSaving() -> Bool{
        let areAllFieldsComplete = self.areAllFieldsComplete()

        if !areAllFieldsComplete {

            self.showAlert(withTitle: incompleteFormTitle, andMessage: incompleteFormMessage, handler: nil)
        }

        return areAllFieldsComplete
    }

    fileprivate func areAllFieldsComplete() -> Bool {
        
        if isUsernameComplete() && isPasswordComplete() && isURLComplete() {
            return true
        }
        
        return false
    }
    
    fileprivate func isUsernameComplete() -> Bool {
        
        if username.text == nil || username.text == "" {
            return false
        }
        
        return true
    }
    
    fileprivate func isPasswordComplete() -> Bool {
        
        if password.text == nil || password.text == "" {
            return false
        }
        
        return true
    }

    fileprivate func isURLComplete() -> Bool {
        
        if url.text == nil || url.text == "" {
            return false
        }
        
        return true
    }

    // MARK: - Cancel
    func cancel() {
        if self.viewType == .add {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
