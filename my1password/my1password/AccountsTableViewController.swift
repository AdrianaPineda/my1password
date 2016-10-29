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
    let addAccountSelector: Selector = #selector(AccountsTableViewController.addAccount)

    // MARK: - Properties
    var userAccountsManager: UserAccountsManager = UserAccountsManager.userAccounts
    fileprivate let accountsUseCase = AccountsUseCase()

    var accounts = [NSManagedObject]()
    var filteredAccounts = [NSManagedObject]()

    let searchController: UISearchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle
    override func viewDidLoad() {

        super.viewDidLoad()
        self.configureUI()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.configureRightBarButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.removeRightBarButton()
    }

    // MARK: - Configure UI

    fileprivate func reloadUI() {
        self.configureUI()
        self.tableView.reloadData()
    }

    fileprivate func configureUI() {

        // Load accounts
        accounts = accountsUseCase.loadAccounts()

        // Configure right bar button
        self.configureRightBarButton()

        // Configure search bar
        self.configureSearchBar()

    }

    fileprivate func configureRightBarButton() {
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: addAccountSelector)
        self.tabBarController?.navigationItem.rightBarButtonItem = addButtonItem
    }

    fileprivate func removeRightBarButton() {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }

    fileprivate func configureSearchBar() {

        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar

    }

    // MARK: - Search bar
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(self.searchController.searchBar.text!)
    }

    fileprivate func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.filteredAccounts = self.accounts.filter { account in

            guard let accountUsername = account.value(forKey: "username") else {
                return false
            }

            guard let accountUrl = account.value(forKey: "url") else {
                return false
            }

            let isAccountAMatch: Bool = (accountUsername as AnyObject).lowercased.contains(searchText.lowercased()) || (accountUrl as AnyObject).lowercased.contains(searchText.lowercased())

            return isAccountAMatch
        }

        self.tableView.reloadData()
    }

    fileprivate func isSearching() -> Bool {

        if self.searchController.isActive && self.searchController.searchBar.text != "" {
            return true
        }

        return false
    }

    // MARK: - Table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.isSearching() {
            return self.filteredAccounts.count
        }

        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: accountRowIdentifier, for: indexPath)

        cell.selectionStyle = UITableViewCellSelectionStyle.none

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
            cell.textLabel?.text = currentAccount!.value(forKey: "username") as? String
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: showAccountSegueId, sender: self)

    }

    // MARK: - Edit Account
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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

    fileprivate func configureAccountInfoForEditSegue(_ segue: UIStoryboardSegue, withAccount account: NSManagedObject) {

        let nextController: AccountInfoTableViewController = segue.destination as! AccountInfoTableViewController
        nextController.setViewType(.edit)
        nextController.setAccount(account)
        nextController.delegate = self
    }


    // MARK: - Add Account
    func addAccount() {

        let addAccountTableViewController = self.storyboard?.instantiateViewController(withIdentifier: addAccountTableViewControllerId) as! AccountInfoTableViewController

        addAccountTableViewController.delegate = self

        let navigationController = UINavigationController(rootViewController: addAccountTableViewController)

        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }

    // MARK: - ReloadTableViewDelegate
    func reloadTable(_ sender: UIViewController) {

        if let accountViewSender: AccountInfoTableViewController = sender as? AccountInfoTableViewController {

            if accountViewSender.getViewType() == .add {
                sender.dismiss(animated: true, completion: nil)
            } else {
                accountViewSender.navigationController?.popViewController(animated: true)
            }

        }

        self.reloadUI()
    }

}
