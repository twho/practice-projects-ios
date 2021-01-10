//
//  People.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/28/20.
//

struct People: Equatable {
    let id: Int
    let personName: String
    let username: String
    let email: String
    let phone: String
    let company: Company?
    let website: String
    
    init(_ id: Int, _ name: String, _ username: String, _ email: String, _ phone: String, _ company: Company?, _ website: String) {
        self.id = id
        self.personName = name
        self.username = username
        self.email = email
        self.phone = phone
        self.company = company
        self.website = website
    }
}

extension People: Decodable {
    // CodingKeys have to match JSON parameter names
    private enum CodingKeys: String, CodingKey {
        case id, name, username, email, phone, company, website
    }
    
    init(from decoder: Decoder) throws {
        // defining our (keyed) container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // extracting the data
        let id: Int = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        let name: String = try container.decodeIfPresent(String.self, forKey: .name) ?? "NULL"
        let username: String = try container.decodeIfPresent(String.self, forKey: .username) ?? "NULL"
        let email: String = try container.decodeIfPresent(String.self, forKey: .email) ?? "NULL"
        let phone: String = try container.decodeIfPresent(String.self, forKey: .phone) ?? "NULL"
        let company: Company? = try container.decode(Company?.self, forKey: .company)
        let website: String = try container.decodeIfPresent(String.self, forKey: .website) ?? "NULL"
        // Init the object
        self.init(id, name, username, email, phone, company, website)
    }
}

extension People: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(personName, forKey: .name)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        try container.encode(company, forKey: .company)
        try container.encode(website, forKey: .website)
    }
}
