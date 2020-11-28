//
//  ImageDisplayControllerTests.swift
//  InterviewPracticesTests
//
//  Created by Michael Ho on 11/26/20.
//

import XCTest

@testable import InterviewPractices
class ImageDisplayControllerTests: XCTestCase {
    var imageDisplayVC: MockImageDisplayViewController!
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    override func setUpWithError() throws {
        // Add the view controller to the hierarchy
        imageDisplayVC = MockImageDisplayViewController()
        window?.makeKeyAndVisible()
        window?.rootViewController = imageDisplayVC
        _ = imageDisplayVC.view
        // Run view controller life cycle
        imageDisplayVC.viewDidLoad()
        imageDisplayVC.viewDidLayoutSubviews()
        imageDisplayVC.viewDidAppear(false)
    }

    override func tearDownWithError() throws {
        window?.removeSubviews()
        window = nil
        MockGCDHelper.sharedMock.removeAllTasks()
    }
    
    private func getCell(forItem item: Int) -> ImageDisplayViewCell {
        return imageDisplayVC.collectionView(imageDisplayVC.collectionView, cellForItemAt: IndexPath(row: item, section: 0)) as! ImageDisplayViewCell
    }
    
    func testInitialState() {
        XCTAssertNotNil(imageDisplayVC.navbar)
        XCTAssertNotNil(imageDisplayVC.collectionView)
        // Check delegate and data source assignment
        XCTAssertTrue(imageDisplayVC.collectionView.delegate is MockImageDisplayViewController)
        XCTAssertTrue(imageDisplayVC.collectionView.dataSource is MockImageDisplayViewController)
        // Check initial load
        XCTAssertEqual(imageDisplayVC.testData.count, imageDisplayVC.collectionView(imageDisplayVC.collectionView, numberOfItemsInSection: 0))
    }
    
    func testCollectionCellLoaded() {
        let data = imageDisplayVC.testData
        // Test first cell
        let cell1 = getCell(forItem: 0)
        XCTAssertEqual(cell1.title.text, data[0].name)
        // Test second cell
        let cell2 = getCell(forItem: 1)
        XCTAssertEqual(cell2.title.text, data[1].name)
        // Test third cell
        let cell3 = getCell(forItem: 2)
        XCTAssertEqual(cell3.title.text, data[2].name)
    }
    
    func testCollectionViewReloadCellWhenDataChanged() {
        // Setup test
        XCTAssertEqual(3, imageDisplayVC.collectionView.numberOfItems(inSection: 0))
        // Update with another data set
        var newData = [imageDisplayVC.testData[1]]
        imageDisplayVC.state = .populated(newData)
        MockGCDHelper.sharedMock.dequeueAndRunTask()
        XCTAssertEqual(getCell(forItem: 0).title.text, newData[0].name)
        XCTAssertEqual(1, imageDisplayVC.collectionView.numberOfItems(inSection: 0))
        // Update with empty data set
        newData = []
        imageDisplayVC.state = .populated(newData)
        MockGCDHelper.sharedMock.dequeueAndRunTask()
        XCTAssertEqual(0, imageDisplayVC.collectionView.numberOfItems(inSection: 0))
    }
}
