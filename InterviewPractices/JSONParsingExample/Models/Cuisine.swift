//
//  Cuisine.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/23/20.
//

struct Cuisine: Equatable {
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

extension Cuisine: Decodable {
    private enum CodingKeys : String, CodingKey {
        case cuiId, restaurant, name, price
    }
    
    init(from decoder: Decoder) throws {
        // defining our (keyed) container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // extracting the data
        let cuiId: Int = try container.decode(Int.self, forKey: .cuiId)
        let restaurant: String = try container.decode(String.self, forKey: .restaurant)
        let name: String = try container.decode(String.self, forKey: .name)
        let price: Double = try container.decode(Double.self, forKey: .price)
        // Init the object
        self.init(cuiId, restaurant, name, price)
    }
}
