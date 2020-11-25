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

    enum JSONFileName {
        /// The JSON file stores restaurant data.
        case restaurants
        /// The JSON file stores cuisine data.
        case cuisines
        /**
         
         */
        var name: String {
            switch self {
            case .restaurants: return "RestaurantSample"
            case .cuisines: return "CuisineSample"
            }
        }
        /**
         
         */
        var directory: String {
            switch self {
            case .restaurants: return "restaurants"
            case .cuisines: return "cuisines"
            }
        }
    }
}
