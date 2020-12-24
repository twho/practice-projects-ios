//
//  Meal.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/23/20.
//

struct Meal: Equatable {
    let mealId: Int
    let name: String
    let price: Double
    let category: String
    
    init(_ mealId: Int, _ name: String, _ price: Double, _ category: String) {
        self.mealId = mealId
        self.name = name
        self.price = price
        self.category = category
    }
}

extension Meal: Decodable {
    private enum CodingKeys : String, CodingKey {
        case mealId, name, price, category
    }
    
    init(from decoder: Decoder) throws {
        // defining our (keyed) container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // extracting the data
        
        let mealId: Int = try container.decodeIfPresent(Int.self, forKey: .mealId) ?? -1
        let name: String = try container.decodeIfPresent(String.self, forKey: .name) ?? "NULL"
        let price: Double = try container.decodeIfPresent(Double.self, forKey: .price) ?? -1.0
        let category: String = try container.decodeIfPresent(String.self, forKey: .category) ?? "NULL"
        // Init the object
        self.init(mealId, name, price, category)
    }
}
