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
        let testBundle = MockJSONHelper.sharedMock.getCurrentBundle()
        let filePath = testBundle.path(forResource: MockConstants.TestJSON.restaurants.name, ofType: "json")
        XCTAssertNotNil(filePath)
    }
    
    func testReadRestaurantJSON() {
        let restaurantData = MockJSONHelper.sharedMock.readLocalJSONFile(MockConstants.TestJSON.restaurants.name, Restaurant.self, MockConstants.TestJSON.restaurants.directory)
        XCTAssertEqual(Restaurant(101, "Sample1", 3.0, "1,101", "123-456-7890", "https://dummyimage.com/600x400/ff0000/ff0000"), restaurantData[0])
        XCTAssertEqual(Restaurant(202, "Sample2", 4.0, "2,202", "123-456-7891", "https://dummyimage.com/600x400/ffff00/ffff00"), restaurantData[1])
        XCTAssertEqual(Restaurant(303, "Sample3", 5.0, "3,303", "123-456-7892", "https://dummyimage.com/600x400/ffffff/ffffff"), restaurantData[2])
    }
    
    func testCuisineStruct() {
        let id = 100
        let name = "ABCDEFG"
        let price = 1000.0
        let cat = "HIJKL"
        let meal = Meal(id, name, price, cat)
        XCTAssertNotNil(meal)
        XCTAssertEqual(id, meal.mealId)
        XCTAssertEqual(name, meal.name)
        XCTAssertEqual(price, meal.price)
        XCTAssertEqual(cat, meal.category)
    }
    
    func testReadCuisineJSON() {
        // Check the first data sample
        let data1 = MockJSONHelper.sharedMock.readLocalJSONFile(MockConstants.TestJSON.restaurants.name, Meal.self, MockConstants.TestJSON.meals("Sample1").directory)
        XCTAssertEqual(Meal(101, "meal101", 1.0, "cat11"), data1[0])
        XCTAssertEqual(Meal(102, "meal102", 2.0, "cat12"), data1[1])
        XCTAssertEqual(Meal(103, "meal103", 3.0, "cat13"), data1[2])
        // Check another data sample
        let data2 = MockJSONHelper.sharedMock.readLocalJSONFile(MockConstants.TestJSON.restaurants.name, Meal.self, MockConstants.TestJSON.meals("Sample2").directory)
        XCTAssertEqual(Meal(202, "meal202", 4.0, "cat21"), data2[0])
        XCTAssertEqual(Meal(203, "meal203", 5.0, "cat22"), data2[1])
        XCTAssertEqual(Meal(204, "meal204", 6.0, "cat23"), data2[2])
    }
}
