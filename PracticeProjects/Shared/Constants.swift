//
//  Constants.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/24/20.
//

import UIKit

struct Constants {
    /**
     Practice examples in the current project scope.
     */
    enum Example {
        /// JSON decoding demo example.
        case jsonDecoding
        /// Image loading example.
        case imageLoader
        /// Rest API example.
        case restAPI
        /// Hit test and responder chain example.
        case hitTestResponder
        /// GCD and lock/deadlock examples.
        case GCDExample
        /// Design of container controllers.
        case containerController
        /**
         The title of the example to display in navigation bar.
         */
        var title: String {
            switch self {
            case .jsonDecoding: return "JSON Parsing Example"
            case .imageLoader: return "Image Loading Example"
            case .restAPI: return "RESTful API Example"
            case .hitTestResponder: return "Hit Test and Responder Chain"
            case .GCDExample: return "GCD and Lock/Deadlock"
            case .containerController: return "Container Controllers"
            }
        }
        /**
         The view controller that demonstrate the example.
         */
        var viewController: UIViewController {
            switch self {
            case .jsonDecoding: return ListViewController()
            case .imageLoader: return ImageDisplayViewController()
            case .restAPI: return ContactsViewController()
            case .hitTestResponder: return HitTestViewController()
            case .GCDExample: return GCDViewController()
            case .containerController: return ReuseNavigationController(rootViewController: AFirstViewController())
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
