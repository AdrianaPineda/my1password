//
//  AccountsTableViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 5/10/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit
import CoreData

class AccountsTableViewController: UITableViewController, ReloadTableViewDelegate, UISearchResultsUpdating {

    // MARK: - Constants
    let addAccountTableViewControllerId: String = "addAccountTableViewController"
    let showAccountSegueId: String = "showAccount"
    let accountRowIdentifier: String = "accountRow"

    // MARK: - Selectors
    let addAccountSelector: Selector = Selector("addAccount")

    // MARK: - Properties
    var userAccountsManager: UserAccountsManager = UserAccountsManager.userAccounts

    var accounts = [NSManagedObject]()
    var filteredAccounts = [NSManagedObject]()

    let searchController: UISearchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle
    override func viewDidLoad() {

        super.viewDidLoad()
        self.configureUI()

    }

    override func viewWillAppear(animated: Bool) {
        self.configureRightBarButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(animated: Bool) {
        self.removeRightBarButton()
    }

    // MARK: - Configure UI

    private func reloadUI() {
        self.configureUI()
        self.tableView.reloadData()
    }

    private func configureUI() {

        // Load accounts
        accounts = self.fetchAccounts()

        // Configure right bar button
        self.configureRightBarButton()

        // Configure search bar
        self.configureSearchBar()

    }

    private func fetchAccounts() -> [NSManagedObject] {
        
        let accountsUseCase = AccountsUseCase()
        return accountsUseCase.loadAccounts()
    }

    private func configureRightBarButton() {
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: addAccountSelector)
        self.tabBarController?.navigationItem.rightBarButtonItem = addButtonItem
    }

    private func removeRightBarButton() {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }

    private func configureSearchBar() {

        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar

    }

    // MARK: - Search bar
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filterContentForSearchText(self.searchController.searchBar.text!)
    }

    private func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredAccounts = self.accounts.filter { account in

            guard let accountUsername = account.valueForKey("username") else {
                return false
            }

            guard let accountUrl = account.valueForKey("url") else {
                return false
            }

            let isAccountAMatch: Bool = accountUsername.lowercaseString.containsString(searchText.lowercaseString) || accountUrl.lowercaseString.containsString(searchText.lowercaseString)

            return isAccountAMatch
        }

        self.tableView.reloadData()
    }

    private func isSearching() -> Bool {

        if self.searchController.active && self.searchController.searchBar.text != "" {
            return true
        }

        return false
    }

    // MARK: - Table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.isSearching() {
            return self.filteredAccounts.count
        }

        return accounts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(accountRowIdentifier, forIndexPath: indexPath)

        cell.selectionStyle = UITableViewCellSelectionStyle.None

        var currentAccount: NSManagedObject?
        let cellRow: Int = indexPath.row

        if self.isSearching() && filteredAccounts.count > 0  && cellRow < filteredAccounts.count {
            currentAccount = filteredAccounts[cellRow]
        } else {
            if accounts.count > 0 && cellRow < accounts.count {
                currentAccount = accounts[indexPath.row]
            }
        }

        if currentAccount != nil {
            cell.textLabel?.text = currentAccount!.valueForKey("username") as? String
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.performSegueWithIdentifier(showAccountSegueId, sender: self)

    }

    // MARK: - Edit Account
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier != showAccountSegueId {
            return
        }

        let accountRow: Int = (self.tableView.indexPathForSelectedRow?.row)!

        if self.accounts.count <= accountRow {
            return
        }

        if let currentAccount: NSManagedObject = self.accounts[accountRow] as NSManagedObject {
            self.configureAccountInfoForEditSegue(segue, withAccount: currentAccount)
        }
    }

    private func configureAccountInfoForEditSegue(segue: UIStoryboardSegue, withAccount account: NSManagedObject) {

        let nextController: AccountInfoTableViewController = segue.destinationViewController as! AccountInfoTableViewController
        nextController.setViewType(.Edit)
        nextController.setAccount(account)
        nextController.delegate = self
    }


    // MARK: - Add Account
    func addAccount() {

        let addAccountTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier(addAccountTableViewControllerId) as! AccountInfoTableViewController

        addAccountTableViewController.delegate = self

        let navigationController = UINavigationController(rootViewController: addAccountTableViewController)

        self.navigationController?.presentViewController(navigationController, animated: true, completion: nil)
    }

    // MARK: - ReloadTableViewDelegate
    func reloadTable(sender: UIViewController) {

        if let accountViewSender: AccountInfoTableViewController = sender as? AccountInfoTableViewController {

            if accountViewSender.getViewType() == .Add {
                sender.dismissViewControllerAnimated(true, completion: nil)
            } else {
                accountViewSender.navigationController?.popViewControllerAnimated(true)
            }

        }

        self.reloadUI()
    }

}
