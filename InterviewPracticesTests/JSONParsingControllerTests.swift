//
//  JSONParsingControllerTests.swift
//  InterviewPracticesTests
//
//  Created by Michael Ho on 11/24/20.
//

import XCTest

@testable import InterviewPractices
class JSONParsingControllerTests: XCTestCase {
    var listVC: MockListViewController!

    override func setUpWithError() throws {
        listVC = MockListViewController()
        // Load view
        listVC.viewDidLoad()
        listVC.viewDidAppear(false)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUIShouldNotBeNil() {
        XCTAssertNotNil(listVC.navbar)
        XCTAssertNotNil(listVC.tableView)
    }
    
    func testTableViewSetup() {
        // Check delegate and data source assignment
        XCTAssertTrue(listVC.tableView.delegate is ListViewController)
        XCTAssertTrue(listVC.tableView.dataSource is ListViewController)
        // Check initial load
        XCTAssertEqual(listVC.restaurantData.count, listVC.tableView(listVC.tableView, numberOfRowsInSection: 0))
    }
    
    func testTableViewCellLoaded() {
        let data = listVC.restaurantData
        let cell = listVC.tableView(listVC.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is ListTableViewCell)
        // Test first cell
        let cell1 = listVC.tableView(listVC.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! ListTableViewCell
        XCTAssertEqual(cell1.title.text, data[0].name)
        XCTAssertEqual(cell1.phoneLabel.text, "#" + data[0].phoneNumber)
        // Test second cell
        let cell2 = listVC.tableView(listVC.tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as! ListTableViewCell
        XCTAssertEqual(cell2.title.text, data[1].name)
        XCTAssertEqual(cell2.phoneLabel.text, "#" + data[1].phoneNumber)
        // Test third cell
        let cell3 = listVC.tableView(listVC.tableView, cellForRowAt: IndexPath(row: 2, section: 0)) as! ListTableViewCell
        XCTAssertEqual(cell3.title.text, data[2].name)
        XCTAssertEqual(cell3.phoneLabel.text, "#" + data[2].phoneNumber)
    }
}
