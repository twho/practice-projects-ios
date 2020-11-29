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
    let company: Company
    let website: String
    
    init(_ id: Int, _ name: String, _ username: String, _ email: String, _ phone: String, _ company: Company, _ website: String) {
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
        let id: Int = try container.decode(Int.self, forKey: .id)
        let name: String = try container.decode(String.self, forKey: .name)
        let username: String = try container.decode(String.self, forKey: .username)
        let email: String = try container.decode(String.self, forKey: .email)
        let phone: String = try container.decode(String.self, forKey: .phone)
        let company: Company = try container.decode(Company.self, forKey: .company)
        let website: String = try container.decode(String.self, forKey: .website)
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
        let name: String = try container.decode(String.self, forKey: .name)
        let catchPhrase: String = try container.decode(String.self, forKey: .catchPhrase)
        let bs: String = try container.decode(String.self, forKey: .bs)
        // Init the object
        self.init(name, catchPhrase, bs)
    }
}
