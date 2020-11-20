//
//  JSONParser.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/19/20.
//

import Foundation

class JSONHelper {
    /**
     
     */
    func readLocalJSONFile(_ fileName: String, _ resultsType: String) -> [Any] {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let results = jsonResult[resultsType] as? [Any] {
                    return results
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return []
    }
}
