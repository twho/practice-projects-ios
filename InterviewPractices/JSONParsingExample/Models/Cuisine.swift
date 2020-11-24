//
//  Cuisine.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/23/20.
//

struct Cuisine {
    let cuisineId: Int
    let restaurant: String
    let name: String
    let price: Double
    
    init(_ cuisineId: Int, _ restaurant: String, _ name: String, _ price: Double) {
        self.cuisineId = cuisineId
        self.restaurant = restaurant
        self.name = name
        self.price = price
    }
}
