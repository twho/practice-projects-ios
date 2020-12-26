//
//  RestAPIHelper.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/28/20.
//

import UIKit

class RestAPIHelper {
    /**
     Fetch the data in JSON format from web and decode it into data object for the use in the app.
     
     - Parameter urlString:  The URL in string format to fetch data.
     - Parameter dataType:   The object type to convert JSON data to.
     - Parameter key:        The key used in JSON to query results.
     - Parameter completion: The completion handler to return results or errors.
     */
    static func fetch<T: Decodable>(_ urlString: String, _ dataType: T.Type, _ key: String?, _ completion: @escaping (Result<[T], Error>) -> Void) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    JSONHelper.shared.decodeJSONToArray(data, T.self, key) { result in
                        completion(result)
                    }
                }
            }
            task.resume()
        }
    }
    /*
     Plain code example
     
     JSON format:
     [
         {
           "id": 1,
           "name": "Leanne Graham",
           "username": "Bret",
           "email": "Sincere@april.biz",
           "address": {
             "street": "Kulas Light",
             "suite": "Apt. 556",
             "city": "Gwenborough",
             "zipcode": "92998-3874",
             "geo": {
               "lat": "-37.3159",
               "lng": "81.1496"
             }
           },
           "phone": "1-770-736-8031 x56442",
           "website": "hildegard.org",
           "company": {
             "name": "Romaguera-Crona",
             "catchPhrase": "Multi-layered client-server neural-net",
             "bs": "harness real-time e-markets"
           }
         },
         {
            ...
         }
         ...
     ]
     
     static func decodeJSON(_ url: URL, _ completion: @escaping (Result<[People], Error>) -> Void) {
         let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
             if let error = error {
                 completion(.failure(error))
             } else if let data = data {
                 // There are usually data returned, so check errors first.
                 do {
                     let array = try JSONDecoder().decode([People].self, from: data)
                     completion(.success(array))
                 } catch {
                     completion(.failure(error))
                 }
             }
         }
         task.resume()
     }
     */
}
