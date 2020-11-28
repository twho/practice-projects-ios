//
//  JSONParsingControllerTests.swift
//  InterviewPracticesTests
//
//  Created by Michael Ho on 11/24/20.
//

import XCTest

@testable import InterviewPractices
class ListViewControllerTests: XCTestCase {
    var listVC: MockListViewController!
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    override func setUpWithError() throws {
        // Add the view controller to the hierarchy
        listVC = MockListViewController()
        window?.makeKeyAndVisible()
        window?.rootViewController = listVC
        _ = listVC.view
        // Run view controller life cycle
        listVC.viewDidLoad()
        listVC.viewDidLayoutSubviews()
        listVC.viewDidAppear(false)
    }

    override func tearDownWithError() throws {
        window?.removeSubviews()
        window = nil
    }
    
    private func getCell(forRow row: Int) -> MockListTableViewCell {
        return listVC.tableView(listVC.tableView, cellForRowAt: IndexPath(row: row, section: 0)) as! MockListTableViewCell
    }
    
    func testInitialState() {
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
        let newData = [listVC.restaurantData[1]]
        listVC.restaurantData = newData
        XCTAssertEqual(getCell(forRow: 0).title.text, newData[0].name)
        XCTAssertEqual(1, listVC.tableView.numberOfRows(inSection: 0))
        // Update with empty data set
        listVC.restaurantData = []
        XCTAssertEqual(0, listVC.tableView.numberOfRows(inSection: 0))
    }
    
    func testSelectCellPresentDetailViewController() {
        listVC.tableView(listVC.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        XCTAssertTrue(window?.rootViewController?.presentedViewController is ListDetailViewController)
    }
    
    func testPresentedDetailViewControllerHasDataSetup() {
        listVC.tableView(listVC.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        let detailVC = window?.rootViewController?.presentedViewController as! ListDetailViewController
        XCTAssertEqual(listVC.restaurantData[1], detailVC.restaurant)
    }
    
    func testPresentedDetailViewControllerHasImageSetup() {
        let cellImage = getCell(forRow: 1).restaurantImageView.image
        // Setup test
        XCTAssertNotNil(cellImage)
        listVC.tableView(listVC.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        let detailVC = window?.rootViewController?.presentedViewController as! ListDetailViewController
        // Check image in detail view controller
        XCTAssertNotNil(detailVC.imageView.image)
        XCTAssertTrue(cellImage!.cropToWideRatio()!.isContentEqualTo(detailVC.imageView.image!))
    }
}
