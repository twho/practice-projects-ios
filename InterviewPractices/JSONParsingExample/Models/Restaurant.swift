//
//  Restaurant.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/19/20.
//

struct Restaurant {
    let resId: Int
    let name: String
    let rating: Double
    let priceRange: String
    let phoneNumber: String
    let thumbnail: String
    
    init(_ resId: Int, _ name: String, _ rating: Double, _ priceRange: String, _ phoneNumber: String, _ thumbnail: String) {
        self.resId = resId
        self.name = name
        self.rating = rating
        self.priceRange = priceRange
        self.phoneNumber = phoneNumber
        self.thumbnail = thumbnail
    }
}

extension Restaurant: Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case resId, name, rating, priceRange, phoneNumber, thumbnail
    }
    
    init(from decoder: Decoder) throws {
        // defining our (keyed) container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // extracting the data
        let resId: Int = try container.decode(Int.self, forKey: .resId)
        let name: String = try container.decode(String.self, forKey: .name)
        let rating: Double = try container.decode(Double.self, forKey: .rating)
        let priceRange: String = try container.decode(String.self, forKey: .priceRange)
        let phoneNumber: String = try container.decode(String.self, forKey: .phoneNumber)
        let thumbnail: String = try container.decode(String.self, forKey: .thumbnail)
        // Init the object
        self.init(resId, name, rating, priceRange, phoneNumber, thumbnail)
    }
}
