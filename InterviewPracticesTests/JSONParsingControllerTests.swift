//
//  JSONParsingControllerTests.swift
//  InterviewPracticesTests
//
//  Created by Michael Ho on 11/24/20.
//

import XCTest

@testable import InterviewPractices
class JSONParsingControllerTests: XCTestCase {
    var listVC: ListViewController!

    override func setUpWithError() throws {
        listVC = ListViewController()
        // Load view
        _ = listVC.view
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUIShouldNotBeNil() {
        XCTAssertNotNil(listVC.navbar)
        XCTAssertNotNil(listVC.tableView)
    }
    
    func testTableViewSetup() {
        XCTAssertTrue(listVC.tableView.delegate is ListViewController)
        XCTAssertTrue(listVC.tableView.dataSource is ListViewController)
        
        listVC.restaurantData = [Restaurant(0, "", 0.0, "", "", ""), Restaurant(0, "", 0.0, "", "", "")]
        listVC.viewDidLoad()
        XCTAssertEqual(listVC.restaurantData.count, listVC.tableView(listVC.tableView, numberOfRowsInSection: 0))
    }
}
