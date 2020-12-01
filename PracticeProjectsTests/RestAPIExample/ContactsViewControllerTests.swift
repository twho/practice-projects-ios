//
//  ContactsViewControllerTests.swift
//  PracticeProjectsTests
//
//  Created by Amy Shih on 11/28/20.
//

import XCTest

@testable import PracticeProjects
class ContactsViewControllerTests: XCTestCase {
    var contactsVC: MockContactsViewController!
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    override func setUpWithError() throws {
        // Add the view controller to the hierarchy
        contactsVC = MockContactsViewController()
        window?.makeKeyAndVisible()
        window?.rootViewController = contactsVC
        _ = contactsVC.view
        // Run view controller life cycle
        contactsVC.viewDidLoad()
        contactsVC.viewDidLayoutSubviews()
        contactsVC.viewDidAppear(false)
        MockGCDHelper.sharedMock.runAllTasksInQueue()
    }
    
    override func tearDownWithError() throws {
        window?.removeSubviews()
        window = nil
        MockGCDHelper.sharedMock.removeAllTasks()
    }
    
    private func getCell(forRow row: Int) -> UITableViewCell {
        return contactsVC.tableView(contactsVC.tableView, cellForRowAt: IndexPath(row: row, section: 0))
    }
    
    func testSelectCellPresentUserCardViewController() {
        contactsVC.tableView(contactsVC.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        XCTAssertTrue(window?.rootViewController?.presentedViewController is UserCardViewController)
    }
    
    func testPresentedUserCardViewControllerHasDataSetup() {
        contactsVC.tableView(contactsVC.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        let userCardVC = window?.rootViewController?.presentedViewController as! UserCardViewController
        XCTAssertEqual(contactsVC.peopleData![1], userCardVC.people)
    }
    
    func testTableViewCellLoaded() {
        let data = contactsVC.testData
        // Test first cell
        let cell1 = getCell(forRow: 0)
        XCTAssertNotNil(cell1.textLabel)
        XCTAssertEqual(cell1.textLabel?.text, data[0].name)
        XCTAssertEqual(cell1.detailTextLabel?.text, data[0].phone)
        // Test second cell
        let cell2 = getCell(forRow: 1)
        XCTAssertNotNil(cell2.textLabel)
        XCTAssertEqual(cell2.textLabel?.text, data[1].name)
        XCTAssertEqual(cell2.detailTextLabel?.text, data[1].phone)
        // Test third cell
        let cell3 = getCell(forRow: 2)
        XCTAssertNotNil(cell3.textLabel)
        XCTAssertEqual(cell3.textLabel?.text, data[2].name)
        XCTAssertEqual(cell3.detailTextLabel?.text, data[2].phone)
    }
    
    func testTableViewReloadCellWhenSearched() {
        let data = contactsVC.testData
        contactsVC.searchBar(contactsVC.searchBar, textDidChange: data[0].name)
        // Don't load the result after 0.5 seconds so the search requests won't queue up.
        XCTAssertEqual(3, contactsVC.tableView.numberOfRows(inSection: 0))
        // After the time has passed.
        MockGCDHelper.sharedMock.runAllTasksInQueue()
        XCTAssertEqual(1, contactsVC.tableView.numberOfRows(inSection: 0))
        XCTAssertEqual(data[0].name, getCell(forRow: 0).textLabel?.text)
    }
}
