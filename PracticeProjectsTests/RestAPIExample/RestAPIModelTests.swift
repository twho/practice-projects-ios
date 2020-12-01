//
//  RestAPIModelTests.swift
//  PracticeProjectsTests
//
//  Created by Amy Shih on 11/30/20.
//

import XCTest

@testable import PracticeProjects
class RestAPIModelTests: XCTestCase {
    
    func testPeopleStruct() {
        let id = 100
        let name = "ABCDEFG"
        let username = "HIJKL"
        let email = "abc@def.com"
        let phone = "123-456-7890"
        let company = MockConstants.TestJSON.companies.dummyData[0] as! Company
        let website = "abcdef.com"
        let people = People(id, name, username, email, phone, company, website)
        XCTAssertNotNil(people)
        XCTAssertEqual(id, people.id)
        XCTAssertEqual(name, people.name)
        XCTAssertEqual(username, people.username)
        XCTAssertEqual(email, people.email)
        XCTAssertEqual(phone, people.phone)
        XCTAssertEqual(company, people.company)
        XCTAssertEqual(website, people.website)
    }
    
    func testReadPeopleJSON() {
        var peopleData = [People]()
        MockJSONHelper.sharedMock.readLocalJSONFile(MockConstants.TestJSON.people.name, People.self, MockConstants.TestJSON.people.directory) { result in
            do {
                peopleData = try result.get()
            } catch {
                XCTAssertThrowsError(error)
            }
        }
        // Note that this test includes the checks of the Company object.
        let companies = MockConstants.TestJSON.companies.dummyData as! [Company]
        XCTAssertEqual(People(101, "First1 Last1", "FirstLast101", "FirstLast101@michaelho.com", "123-456-7891", companies[0], "FirstLast101.org"), peopleData[0])
        XCTAssertEqual(People(202, "First2 Last2", "FirstLast202", "FirstLast202@michaelho.com", "123-456-7892", companies[1], "FirstLast202.net"), peopleData[1])
        XCTAssertEqual(People(303, "First3 Last3", "FirstLast303", "FirstLast303@michaelho.com", "123-456-7893", companies[2], "FirstLast303.info"), peopleData[2])
    }
    
    func testCompanyStruct() {
        let name = "ABCDEFG"
        let phrase = "HIJKL"
        let bs = "MNOPQRS"
        let company = Company(name, phrase, bs)
        XCTAssertNotNil(company)
        XCTAssertEqual(name, company.name)
        XCTAssertEqual(phrase, company.catchPhrase)
        XCTAssertEqual(bs, company.bs)
    }
}
