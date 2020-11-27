//
//  Constants.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/24/20.
//

import UIKit

struct Constants {
    /**
     Interview examples in the current project scope.
     */
    enum Example {
        /// JSON parser demo example.
        case jsonParser
        /// Image loading example.
        case imageLoader
        /**
         The title of the example to display in navigation bar.
         */
        var title: String {
            switch self {
            case .jsonParser: return "JSON Parsing Example"
            case .imageLoader: return "Image Loading Example"
            }
        }
        /**
         The view controller that demonstrate the example.
         */
        var viewController: UIViewController {
            switch self {
            case .jsonParser: return ListViewController()
            case .imageLoader: return ImageDisplayViewController()
            }
        }
    }

    enum JSON {
        /// The JSON file stores restaurant data.
        case restaurants
        /// The JSON file stores meal data.
        case meals(String? = nil)
        /**
         The name of the JSON files.
         */
        var name: String {
            return "RestaurantSample"
        }
        /**
         The name of the key to query in the JSON files.
         */
        var directory: String {
            switch self {
            case .restaurants: return "restaurants"
            case .meals(let restaurantName): return "meals" + (restaurantName != nil ? ",\(restaurantName!)" : "")
            }
        }
    }
}
