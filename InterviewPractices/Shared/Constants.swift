//
//  Constants.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/24/20.
//


struct Constants {
    enum JSONFileName {
        case restaurants, cuisines
        
        var name: String {
            switch self {
            case .restaurants: return "RestaurantSample"
            case .cuisines: return "CuisineSample"
            }
        }
        
        var directory: String {
            switch self {
            case .restaurants: return "restaurants"
            case .cuisines: return "cuisines"
            }
        }
    }
}
