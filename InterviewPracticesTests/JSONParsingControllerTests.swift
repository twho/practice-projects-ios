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
    
    private func getCell(forRow row: Int) -> ListTableViewCell {
        return listVC.tableView(listVC.tableView, cellForRowAt: IndexPath(row: row, section: 0)) as! ListTableViewCell
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
        // Test first cell
        let cell1 = getCell(forRow: 0)
        XCTAssertEqual(cell1.title.text, data[0].name)
        XCTAssertEqual(cell1.phoneLabel.text, "#" + data[0].phoneNumber)
        // Test second cell
        let cell2 = getCell(forRow: 1)
        XCTAssertEqual(cell2.title.text, data[1].name)
        XCTAssertEqual(cell2.phoneLabel.text, "#" + data[1].phoneNumber)
        // Test third cell
        let cell3 = getCell(forRow: 2)
        XCTAssertEqual(cell3.title.text, data[2].name)
        XCTAssertEqual(cell3.phoneLabel.text, "#" + data[2].phoneNumber)
    }
    
    func testTableViewReloadCellWhenDataChanged() {
        // Setup test
        XCTAssertEqual(3, listVC.tableView.numberOfRows(inSection: 0))
        // Update with another data set
        var newData = [listVC.restaurantData[1]]
        listVC.restaurantData = newData
        XCTAssertEqual(getCell(forRow: 0).title.text, newData[0].name)
        XCTAssertEqual(1, listVC.tableView.numberOfRows(inSection: 0))
        // Update with empty data set
        newData = []
        listVC.restaurantData = newData
        XCTAssertEqual(0, listVC.tableView.numberOfRows(inSection: 0))
    }
    
    func testTablViewCellImageFreeUpBeforeReuse() {
        
        let newData = listVC.restaurantData
        listVC.restaurantData = newData + newData + newData
        // Setup test
        XCTAssertEqual(9, listVC.tableView.numberOfRows(inSection: 0))
        XCTAssertNotNil(getCell(forRow: 0).restaurantImageView.image)
        // When scroll down to the bottom
        
//        listVC.tableView.scrollToRow(at: IndexPath(row: 8, section: 0), at: .bottom, animated: false)
//        listVC.tableView.reloadData()
//        let _ = getCell(forRow: 5)
//        let _ = getCell(forRow: 6)
//        let _ = getCell(forRow: 7)
//        
//        // The image inside the cell should be cleaned up since the cell is reused.
//        XCTAssertNil(getCell(forRow: 0).restaurantImageView.image)
    }
}
