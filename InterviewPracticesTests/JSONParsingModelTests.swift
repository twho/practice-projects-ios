//
//  JSONParsingExampleTests.swift
//  InterviewPracticesTests
//
//  Created by Michael Ho on 11/23/20.
//

import XCTest

@testable import InterviewPractices
class JSONParsingExampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRestaurantStruct() {
        let id = 100
        let name = "ABCDEFG"
        let rating = 4.7
        let price = "10,100"
        let phone = "123-456-7890"
        let thumbnail = "www.michaelho.com"
        let restaurant = Restaurant(id, name, rating, price, phone, thumbnail)
        XCTAssertNotNil(restaurant)
        XCTAssertEqual(id, restaurant.resId)
        XCTAssertEqual(name, restaurant.name)
        XCTAssertEqual(rating, restaurant.rating)
        XCTAssertEqual(price, restaurant.priceRange)
        XCTAssertEqual(phone, restaurant.phoneNumber)
        XCTAssertEqual(thumbnail, restaurant.thumbnail)
    }
    
    func testJSONFileExistence() {
        let testBundle = TestJSONHelper.sharedTestHelper.getCurrentBundle()
        let filePath = testBundle.path(forResource: TestConstants.JSON.restaurants.name, ofType: "json")
        XCTAssertNotNil(filePath)
    }
    
    func testReadRestaurantJSON() {
        let restaurantsData = TestJSONHelper.sharedTestHelper.readLocalJSONFile(TestConstants.JSON.restaurants.name, Restaurant.self, TestConstants.JSON.restaurants.directory)
        XCTAssertEqual(restaurantsData.count, 3)
        let expected = Restaurant(202, "Sample2", 4.0, "2,202", "123-456-7891", "https://dummyimage.com/600x400/ffff00/ffff00")
        XCTAssertEqual(restaurantsData[1], expected)
    }
    
    func testCuisineStruct() {
        
    }
    
    func testReadCuisineJSON() {
        
    }
}
