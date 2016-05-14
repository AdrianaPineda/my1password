//
//  AccountsTableViewController.swift
//  my1password
//
//  Created by Adriana Pineda on 5/10/15.
//  Copyright (c) 2015 Adriana Pineda. All rights reserved.
//

import UIKit

class AccountsTableViewController: UITableViewController, ReloadTableViewDelegate {

    var userAccountsManager: UserAccountsManager = UserAccountsManager.userAccounts
    var accounts = [Account]()
//    var filteredAccounts = [Account]()

    let addAccountTableViewControllerId: String = "addAccountTableViewController"
    let showAccountSegueId: String = "showAccount"
    let addAccountSelector: Selector = #selector(AccountsTableViewController.addAccount)
    let accountRowIdentifier: String = "accountRow"

//    let searchController: UISearchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

//        self.searchController.searchResultsUpdater = self
//        self.searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        self.tableView.tableHeaderView = self.searchController.searchBar

        accounts = userAccountsManager.getUserAccounts()

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: addAccountSelector)
        self.tabBarController?.navigationItem.rightBarButtonItem = addButtonItem

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {


//        self.tableView.reloadData()
    }

    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }

    // MARK: - Search bar
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filterContentForSearchText(self.searchController.searchBar.text!)
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredAccounts = self.accounts.filter({ (account: Account) -> Bool in
            let isAccountAMatch: Bool = account.username.lowercaseString.containsString(searchText.lowercaseString) || account.url.lowercaseString.containsString(searchText.lowercaseString)
            return isAccountAMatch
        })

        self.tableView.reloadData()
    }

    // MARK: - Search bar
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        self.filterContentForSearchText(self.searchController.searchBar.text!)
//    }

//    func filterContentForSearchText(searchText: String, scope: String = "All") {
//        self.filteredAccounts = self.accounts.filter({ (account: Account) -> Bool in
//            let isAccountAMatch: Bool = account.username.lowercaseString.containsString(searchText.lowercaseString) || account.url.lowercaseString.containsString(searchText.lowercaseString)
//            return isAccountAMatch
//        })
//
//        self.tableView.reloadData()
//    }

    func isSearching() -> Bool {

//        if self.searchController.active && self.searchController.searchBar.text != "" {
//            return true
//        }

        return false
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Return the number of rows in the section.
//        if self.isSearching() {
//            self.filteredAccounts.count
//        }

        return accounts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(accountRowIdentifier, forIndexPath: indexPath)

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        // Configure the cell...

        var currentAccount: Account? = nil
        let cellRow: Int = indexPath.row
//        if self.isSearching() && filteredAccounts.count > 0  && cellRow < filteredAccounts.count {
//            currentAccount = filteredAccounts[cellRow]
//        } else {
            if accounts.count > 0 && cellRow < accounts.count {
                currentAccount = accounts[indexPath.row]
            }
//        }

        if currentAccount != nil {
            cell.textLabel?.text = currentAccount!.username
        }

        return cell
    }

    // MARK: - Table View
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.performSegueWithIdentifier(showAccountSegueId, sender: self)

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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == showAccountSegueId {

            let nextController: AccountInfoTableViewController = segue.destinationViewController as! AccountInfoTableViewController
            nextController.viewType = .Edit

            let accountRow: Int = (self.tableView.indexPathForSelectedRow?.row)!

            if self.accounts.count > accountRow {

                if let currentAccount: Account = self.accounts[accountRow] as Account {

                    nextController.currentAccount = currentAccount
                    nextController.delegate = self
                }

            }
        }
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
            if accountViewSender.viewType == .Add {
                sender.dismissViewControllerAnimated(true, completion: nil)
            } else {
                accountViewSender.navigationController?.popViewControllerAnimated(true)
            }
        }

        self.tableView.reloadData()
    }

}
