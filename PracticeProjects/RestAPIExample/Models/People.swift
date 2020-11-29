//
//  People.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/28/20.
//

struct People {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let company: Company
    
    init(_ id: Int, _ name: String, _ email: String, _ phone: String, _ company: Company) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.company = company
    }
}

extension People: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, name, email, phone, company
    }
    
    init(from decoder: Decoder) throws {
        // defining our (keyed) container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // extracting the data
        let id: Int = try container.decode(Int.self, forKey: .id)
        let name: String = try container.decode(String.self, forKey: .name)
        let email: String = try container.decode(String.self, forKey: .email)
        let phone: String = try container.decode(String.self, forKey: .phone)
        let company: Company = try container.decode(Company.self, forKey: .company)
        // Init the object
        self.init(id, name, email, phone, company)
    }
}

//extension People: Encodable {
//
//}

struct Company {
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
