//
//  JSONHelper.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/19/20.
//

import Foundation

class JSONHelper {
    // Singleton
    static let shared = JSONHelper()
    init() {}
    /**
     Read a local JSON file in a specific format, e.g., RestaurantSamples.json.
     
     - Parameter fileName:  The JSON file name.
     - Parameter dataType:  The object type to convert JSON data to.
     - Parameter key:       The key used in JSON to read results.
     
     - Returns: An array of the given data type.
     */
    func readLocalJSONFile<T: Decodable>(_ fileName: String, _ dataType: T.Type, _ key: String?, _ completion: @escaping (Result<[T], Error>) -> Void) {
        // Check if the path to the file exists.
        if let path = getCurrentBundle().path(forResource: fileName, ofType: "json") {
            do {
                // The data fetched from JSON file. (Note that when fetching from internet, this part stays the same.)
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.decodeJSONData(data, T.self, key) { result in
                    completion(result)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    /**
     
     */
    func decodeJSONData<T: Decodable>(_ data: Data, _ dataType: T.Type, _ key: String?, _ completion: @escaping (Result<[T], Error>) -> Void) {
        // The input keys to query fetched JSON data.
        var keyArray = [String]()
        if let key = key {
            keyArray = key.components(separatedBy: ",")
        }
        // Initial array to collect data
        var array = [T]()
        do {
            // The data fetched from JSON file. (Note that when fetching from internet, this part stays the same.)
            let primitiveResult = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            //
            var finalResults = primitiveResult
            if keyArray.count > 0, let jsonResult = primitiveResult as? Dictionary<String, AnyObject> {
                var tempResults: Any = jsonResult
                for (idx, key) in keyArray.enumerated() {
                    if idx == keyArray.count - 1,
                       let temp = tempResults as? Dictionary<String, AnyObject>, let results = temp[key] as? [Any] {
                        finalResults = results
                    } else if let temp = tempResults as? Dictionary<String, AnyObject>, let keyResult = temp[key] {
                        tempResults = keyResult
                    }
                }
            }
            
            if let jsonResult = finalResults as? [Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
                    array.append(contentsOf: try JSONDecoder().decode([T].self, from: jsonData))
                } catch {
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
        
        if !array.isEmpty {
            completion(.success(array))
        }
    }
    /**
     Get the bundle reference in the current context.
     
     - Returns: A bundle reference.
     */
    open func getCurrentBundle() -> Bundle {
        return Bundle.main
    }
}
