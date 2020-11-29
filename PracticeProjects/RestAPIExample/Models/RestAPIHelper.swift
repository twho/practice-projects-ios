//
//  RestAPIHelper.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/28/20.
//

import UIKit

class RestAPIHelper {
    // Singleton
    static let shared = RestAPIHelper()
    init() {}
    /**
     
     */
    func fetch<T: Decodable>(_ urlString: String, _ dataType: T.Type, _ key: String?, _ completion: @escaping (Result<[T], Error>) -> Void) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    JSONHelper.shared.decodeJSONData(data, T.self, key) { result in
                        completion(result)
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
