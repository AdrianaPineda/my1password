//
//  UserTests.swift
//  my1password
//
//  Created by Adriana Pineda on 5/12/16.
//  Copyright © 2016 Adriana Pineda. All rights reserved.
//

import XCTest

class UserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

    func testInitWithAccounts_ValidFields() {
        let email = "email"
        let password = "password"
        let accounts: [Account] = []
        let user: User = User(email: email, password: password, accounts: accounts)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.password, password)
        XCTAssertEqual(user.accounts, accounts)
    }

    func testInitWithAccounts_InvalidFields() {

        let email = ""
        let password = ""
        let account = Account(username: "", password: "", url: "")
        let accounts: [Account] = [account]

        let user: User = User(email: email, password: password, accounts: accounts)

        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.password, password)
        XCTAssertEqual(user.accounts, accounts)
        XCTAssertEqual(user.accounts[0], account)
    }

    func testInit_ValidFields() {
        let email = "email"
        let password = "password"
        let user: User = User(email: email, password: password)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.password, password)
    }

    func testInit_EmptyEmail() {
        let emptyField = ""
        let password = "password"
        let user: User = User(email: emptyField, password: password)
        XCTAssertEqual(user.email, emptyField)
        XCTAssertEqual(user.password, password)
    }

    func testInit_EmptyPassword() {
        let emptyField = ""
        let email = "email"
        let user: User = User(email: email, password: emptyField)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.password, emptyField)
    }

    func testAddAccount() {

        let password = "password"
        let email = "email"

        let user: User = User(email: email, password: password)

        var accounts = user.accounts
        XCTAssertTrue(accounts.count == 0)

        let account = Account(username: "u1", password: "p1", url: "u1")

        let accountAdded = user.addAccount(account)

        XCTAssertTrue(accountAdded)

        accounts = user.accounts
        XCTAssertTrue(accounts.count == 1)
        XCTAssertEqual(accounts[0].username, account.username)
        XCTAssertEqual(accounts[0].password, account.password)
        XCTAssertEqual(accounts[0].url, account.url)

    }

}
