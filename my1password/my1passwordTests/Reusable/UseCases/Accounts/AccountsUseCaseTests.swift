//
//  AccountsUseCaseTests.swift
//  my1password
//
//  Created by Adriana Pineda on 10/29/16.
//  Copyright © 2016 Adriana Pineda. All rights reserved.
//

import XCTest
import CoreData

class AccountsUseCaseTests: XCTestCase {
    
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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAddAccount() {
        
        let managedObjectContext = CoreDataHelpers().setUpInMemoryManagedObjectContext()
        
        guard let entity = Account.entity(forManagedContext: managedObjectContext) else {
            XCTFail()
            return
        }
        
        let username = "username_1"
        let password = "password_1"
        let url = "url_1"
        
        let account = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        account.setValue(username, forKey: "username")
        account.setValue(password, forKey: "password")
        account.setValue(url, forKey: "url")
        
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Account")
        do {
            
            guard let accounts: [NSManagedObject] = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] else {
                XCTFail()
                return
            }
            
            XCTAssertTrue(accounts.count == 1)
            XCTAssertTrue(accounts[0].value(forKey: "username") as! String == username)
            XCTAssertTrue(accounts[0].value(forKey: "password") as! String == password)
            XCTAssertTrue(accounts[0].value(forKey: "url") as! String == url)
        
        } catch {
            XCTFail()
        }
    }
    
}
