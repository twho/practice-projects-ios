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
        let filePath = testBundle.path(forResource: MockConstants.JSON.restaurants.name, ofType: "json")
        XCTAssertNotNil(filePath)
    }
    
    func testReadRestaurantJSON() {
        let restaurantData = MockJSONHelper.sharedMock.readLocalJSONFile(MockConstants.JSON.restaurants.name, Restaurant.self, MockConstants.JSON.restaurants.directory)
        XCTAssertEqual(Restaurant(101, "Sample1", 3.0, "1,101", "123-456-7890", "https://dummyimage.com/600x400/ff0000/ff0000"), restaurantData[0])
        XCTAssertEqual(Restaurant(202, "Sample2", 4.0, "2,202", "123-456-7891", "https://dummyimage.com/600x400/ffff00/ffff00"), restaurantData[1])
        XCTAssertEqual(Restaurant(303, "Sample3", 5.0, "3,303", "123-456-7892", "https://dummyimage.com/600x400/ffffff/ffffff"), restaurantData[2])
    }
    
    func testCuisineStruct() {
        let id = 100
        let name = "ABCDEFG"
        let restaurant = "HIJKLMN"
        let price = 1000.0
        let cuisine = Cuisine(id, restaurant, name, price)
        XCTAssertNotNil(cuisine)
        XCTAssertEqual(id, cuisine.cuisineId)
        XCTAssertEqual(restaurant, cuisine.restaurant)
        XCTAssertEqual(name, cuisine.name)
        XCTAssertEqual(price, cuisine.price)
    }
    
    func testReadCuisineJSON() {
        // Check the first data sample
        let restaurant1 = "Sample1"
        let data1 = MockJSONHelper.sharedMock.readLocalJSONFile(MockConstants.JSON.restaurants.name, Cuisine.self, MockConstants.JSON.cuisines(restaurant1).directory)
        XCTAssertEqual(Cuisine(101, restaurant1, "cuisine101", 1.0), data1[0])
        XCTAssertEqual(Cuisine(102, restaurant1, "cuisine102", 2.0), data1[1])
        XCTAssertEqual(Cuisine(103, restaurant1, "cuisine103", 3.0), data1[2])
        // Check another data sample
        let restaurant2 = "Sample2"
        let data2 = MockJSONHelper.sharedMock.readLocalJSONFile(MockConstants.JSON.restaurants.name, Cuisine.self, MockConstants.JSON.cuisines(restaurant2).directory)
        XCTAssertEqual(Cuisine(202, restaurant2, "cuisine202", 4.0), data2[0])
        XCTAssertEqual(Cuisine(203, restaurant2, "cuisine203", 5.0), data2[1])
        XCTAssertEqual(Cuisine(204, restaurant2, "cuisine204", 6.0), data2[2])
    }
}
