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

    func testInitialDataLoad() {
        XCTAssertTrue(detailVC.mealMap.count > 0)
        XCTAssertTrue(detailVC.keyArray.count > 0)
        XCTAssertEqual(detailVC.mealMap.values.count, detailVC.mealData.count)
        XCTAssertEqual(detailVC.keyArray.count, detailVC.mealMap.keys.count)
    }
    
    func testInitialUI() {
        XCTAssertNotNil(detailVC.navbar)
        XCTAssertNotNil(detailVC.tableView)
        XCTAssertEqual(detailVC.headerTitle.text, detailVC.restaurant?.name)
    }
}
