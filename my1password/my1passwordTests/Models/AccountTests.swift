//
//  AccountTests.swift
//  my1password
//
//  Created by Adriana Pineda on 5/14/16.
//  Copyright © 2016 Adriana Pineda. All rights reserved.
//

import XCTest

class AccountTests: XCTestCase {
    
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

    func testInit_ValidFields() {
        let username = "username"
        let password = "password"
        let url = "url"

        let account = Account(username: username, password: password, url: url)

        XCTAssertEqual(username, account.username)
        XCTAssertEqual(password, account.password)
        XCTAssertEqual(url, account.url)
    }

    func testInit_EmptyUsername() {
        let username = ""
        let password = "password"
        let url = "url"

        let account = Account(username: username, password: password, url: url)

        XCTAssertEqual(username, account.username)
        XCTAssertEqual(password, account.password)
        XCTAssertEqual(url, account.url)
    }

    func testInit_EmptyPassword() {
        let username = "username"
        let password = ""
        let url = "url"

        let account = Account(username: username, password: password, url: url)

        XCTAssertEqual(username, account.username)
        XCTAssertEqual(password, account.password)
        XCTAssertEqual(url, account.url)
    }

    func testInit_EmptyUrl() {
        let username = "username"
        let password = "password"
        let url = ""

        let account = Account(username: username, password: password, url: url)

        XCTAssertEqual(username, account.username)
        XCTAssertEqual(password, account.password)
        XCTAssertEqual(url, account.url)
    }
    
}
