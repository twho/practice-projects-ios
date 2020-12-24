//
//  Restaurant.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/19/20.
//

struct Restaurant: Equatable {
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
    
    private enum CodingKeys: String, CodingKey {
        case resId, name, rating, priceRange, phoneNumber, thumbnail
    }
    
    init(from decoder: Decoder) throws {
        // defining our (keyed) container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // extracting the data
        let resId: Int = try container.decodeIfPresent(Int.self, forKey: .resId) ?? -1
        let name: String = try container.decodeIfPresent(String.self, forKey: .name) ?? "NULL"
        let rating: Double = try container.decodeIfPresent(Double.self, forKey: .rating) ?? -1.0
        let priceRange: String = try container.decodeIfPresent(String.self, forKey: .priceRange) ?? "NULL"
        let phoneNumber: String = try container.decodeIfPresent(String.self, forKey: .phoneNumber) ?? "NULL"
        let thumbnail: String = try container.decodeIfPresent(String.self, forKey: .thumbnail) ?? "NULL"
        // Init the object
        self.init(resId, name, rating, priceRange, phoneNumber, thumbnail)
    }
}
