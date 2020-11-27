//
//  Meal.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/23/20.
//

struct Meal: Equatable {
    let mealId: Int
    let name: String
    let price: Double
    
    init(_ mealId: Int, _ name: String, _ price: Double) {
        self.mealId = mealId
        self.name = name
        self.price = price
    }
}

extension Meal: Decodable {
    private enum CodingKeys : String, CodingKey {
        case mealId, name, price
    }
    
    init(from decoder: Decoder) throws {
        // defining our (keyed) container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // extracting the data
        let mealId: Int = try container.decode(Int.self, forKey: .mealId)
        let name: String = try container.decode(String.self, forKey: .name)
        let price: Double = try container.decode(Double.self, forKey: .price)
        // Init the object
        self.init(mealId, name, price)
    }
}
