//
//  People.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/28/20.
//

struct People: Equatable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let company: Company?
    let website: String
    
    init(_ id: Int, _ name: String, _ username: String, _ email: String, _ phone: String, _ company: Company?, _ website: String) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
        self.company = company
        self.website = website
    }
}

extension People: Decodable {
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

struct Company: Equatable {
    let name: String
    let catchPhrase: String
    let bs: String
    
    init(_ name: String, _ catchPhrase: String, _ bs: String) {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}

extension Company: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name, catchPhrase, bs
    }
    
    init(from decoder: Decoder) throws {
        // defining our (keyed) container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // extracting the data
        let name: String = try container.decodeIfPresent(String.self, forKey: .name) ?? "NULL"
        let catchPhrase: String = try container.decodeIfPresent(String.self, forKey: .catchPhrase) ?? "NULL"
        let bs: String = try container.decodeIfPresent(String.self, forKey: .bs) ?? "NULL"
        // Init the object
        self.init(name, catchPhrase, bs)
    }
}
