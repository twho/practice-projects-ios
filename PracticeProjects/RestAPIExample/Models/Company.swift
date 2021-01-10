//
//  Company.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/9/21.
//

struct Company: Equatable {
    let name: String
    let catchPhrase: String
    let bs: String
}

extension Company: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name, catchPhrase, bs
    }
    
    init(from decoder: Decoder) throws {
        // defining our (keyed) container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // extracting the data
        let name = try container.decodeIfPresent(String.self, forKey: .name) ?? "NULL"
        let catchPhrase = try container.decodeIfPresent(String.self, forKey: .catchPhrase) ?? "NULL"
        let bs = try container.decodeIfPresent(String.self, forKey: .bs) ?? "NULL"
        // Init the object
        self.init(name: name, catchPhrase: catchPhrase, bs: bs)
    }
}

extension Company: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(catchPhrase, forKey: .catchPhrase)
        try container.encode(bs, forKey: .bs)
    }
}

