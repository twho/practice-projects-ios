//
//  MenuViewControllerTests.swift
//  InterviewPracticesTests
//
//  Created by Michael Ho on 11/26/20.
//

import XCTest

@testable import InterviewPractices
class MenuViewControllerTests: XCTestCase {
    var menuVC: MenuViewController!
    let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    
    override func setUpWithError() throws {
        // Add the view controller to the hierarchy
        menuVC = MenuViewController()
        window.makeKeyAndVisible()
        window.rootViewController = menuVC
        _ = menuVC.view
        // Run view controller life cycle
        menuVC.viewDidLoad()
        menuVC.viewDidLayoutSubviews()
        menuVC.viewDidAppear(false)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testJSONParserExampleAccessible() {
        for view in menuVC.stackView.arrangedSubviews {
            if let button = view as? UIButton, button.titleLabel?.text == Constants.Example.jsonParser.title {
                menuVC.buttonClicked(button)
                break
            }
        }
        XCTAssertTrue(window.rootViewController?.presentedViewController is ListViewController)
    }
    
    func testImageDisplayExampleAccessible() {
        for view in menuVC.stackView.arrangedSubviews {
            if let button = view as? UIButton, button.titleLabel?.text == Constants.Example.imageLoader.title {
                menuVC.buttonClicked(button)
                break
            }
        }
        XCTAssertTrue(window.rootViewController?.presentedViewController is ImageDisplayViewController)
    }
    
    func testRestAPIExampleAccessible() {
        for view in menuVC.stackView.arrangedSubviews {
            if let button = view as? UIButton, button.titleLabel?.text == Constants.Example.restAPI.title {
                menuVC.buttonClicked(button)
                break
            }
        }
        XCTAssertTrue(window.rootViewController?.presentedViewController is ContactsViewController)
    }
}
