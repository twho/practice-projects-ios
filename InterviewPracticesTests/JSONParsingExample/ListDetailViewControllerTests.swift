//
//  ListDetailViewControllerTests.swift
//  InterviewPracticesTests
//
//  Created by Amy Shih on 11/27/20.
//

import XCTest

@testable import InterviewPractices
class ListDetailViewControllerTests: XCTestCase {
    var detailVC: MockListDetailViewController!
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    override func setUpWithError() throws {
        // Add the view controller to the hierarchy
        detailVC = MockListDetailViewController()
        detailVC.restaurant = MockConstants.TestJSON.restaurants.dummyData[0] as? Restaurant
        window?.makeKeyAndVisible()
        window?.rootViewController = detailVC
        _ = detailVC.view
        // Run view controller life cycle
        detailVC.viewDidLoad()
        detailVC.viewDidLayoutSubviews()
        detailVC.viewDidAppear(false)
    }

    override func tearDownWithError() throws {
        window?.removeSubviews()
        window = nil
    }
    
    private func getCell(forSection section: Int, row: Int) -> UITableViewCell {
        return detailVC.tableView(detailVC.tableView, cellForRowAt: IndexPath(row: row, section: section))
    }

    func testInitialDataLoad() {
        XCTAssertTrue(detailVC.mealMap.count > 0)
        XCTAssertTrue(detailVC.keyArray.count > 0)
        var totalMeals = 0
        for value in detailVC.mealMap.values {
            totalMeals += value.count
        }
        XCTAssertEqual(totalMeals, detailVC.mealData.count)
        XCTAssertEqual(detailVC.keyArray.count, detailVC.mealMap.keys.count)
    }
    
    func testInitialUI() {
        XCTAssertNotNil(detailVC.navbar)
        XCTAssertNotNil(detailVC.tableView)
        XCTAssertEqual(detailVC.headerTitle.text, detailVC.restaurant?.name)
    }
    
    func testTableViewSections() {
        XCTAssertEqual(detailVC.tableView.numberOfSections, detailVC.keyArray.count)
        var section = 0
        var row = 0
        var category = detailVC.keyArray[section]
        XCTAssertEqual(getCell(forSection: section, row: row).textLabel?.text, detailVC.mealMap[category]![row].name)
        section = 1
        row = 1
        category = detailVC.keyArray[section]
        XCTAssertEqual(getCell(forSection: section, row: row).textLabel?.text, detailVC.mealMap[category]![row].name)
    }
    
    func testTableViewReloadedWhenDataUpdated() {
        // Setup test
        XCTAssertEqual(9, detailVC.mealData.count)
        // Update with new data
        let newData = [detailVC.mealData[1]]
        detailVC.mealData = newData
        XCTAssertEqual(getCell(forSection: 0, row: 0).textLabel?.text, newData[0].name)
        XCTAssertEqual(1, detailVC.tableView.numberOfRows(inSection: 0))
        // Update with empty data set
        detailVC.mealData = []
        XCTAssertEqual(0, detailVC.tableView.numberOfSections)
    }
}
