//
//  JSONHelper.swift
//  InterviewPractices
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
    func readLocalJSONFile<T: Decodable>(_ fileName: String, _ dataType: T.Type, _ key: String) -> [T] {
        var array = [T]()
        let keyArr = key.components(separatedBy: ",")
        if let path = getCurrentBundle().path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    var finalResults = [Any]()
                    var tempResults: Any = jsonResult
                    for (idx, key) in keyArr.enumerated() {
                        if idx == keyArr.count - 1,
                           let temp = tempResults as? Dictionary<String, AnyObject>, let results = temp[key] as? [Any] {
                            finalResults = results
                        } else if let temp = tempResults as? Dictionary<String, AnyObject>, let keyResult = temp[key] {
                            tempResults = keyResult
                        }
                    }
                    for dictionary in finalResults {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
                            array.append(try JSONDecoder().decode(T.self, from: jsonData))
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return array
    }
    /**
     
     */
    open func getCurrentBundle() -> Bundle {
        return Bundle.main
    }
}
