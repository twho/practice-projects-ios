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
    }
    
    func testSelectCellPresentUserCardViewController() {
        contactsVC.tableView(contactsVC.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        XCTAssertTrue(window?.rootViewController?.presentedViewController is UserCardViewController)
    }
    
    func testPresentedUserCardViewControllerHasDataSetup() {
        contactsVC.tableView(contactsVC.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        let userCardVC = window?.rootViewController?.presentedViewController as! UserCardViewController
        XCTAssertEqual(contactsVC.peopleData[1], userCardVC.people)
    }
}
