//
//  UserCardViewControllerTests.swift
//  PracticeProjectsTests
//
//  Created by Michael Ho on 1/16/21.
//

import XCTest

@testable import PracticeProjects
class UserCardViewControllerTests: XCTestCase {
    var userCardVC: UserCardViewController!
    var userCardViewModel: UserCardViewModel!
    let targetPerson = (MockConstants.TestJSON.people.dummyData as! [People])[0]
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    override func setUpWithError() throws {
        userCardViewModel = UserCardViewModel(person: targetPerson)
        userCardVC = UserCardViewController(viewModel: userCardViewModel)
        window?.makeKeyAndVisible()
        window?.rootViewController = userCardVC
        _ = userCardVC.view
        // Run view controller life cycle
        userCardVC.viewDidLoad()
        userCardVC.viewDidLayoutSubviews()
        userCardVC.viewWillAppear(false)
        MockGCDHelper.sharedMock.runAllTasksInQueue()
    }
    
    override func tearDownWithError() throws {
        window?.removeSubviews()
        window = nil
        MockGCDHelper.sharedMock.removeAllTasks()
    }
    
    func testDisplayAllInformation() {
        var requiredInfoCount = 5
        for subview in userCardVC.stackView.arrangedSubviews {
            let infoView = subview as! InfoPairView
            var targetValue = ""
            switch infoView.parameterLabel.text {
            case "Username":
                targetValue = targetPerson.username
            case "Email":
                targetValue = targetPerson.email
            case "Phone":
                targetValue = targetPerson.phone
            case "Company":
                targetValue = targetPerson.company?.name ?? ""
            case "Website":
                targetValue = targetPerson.website
            default:
                continue
            }
            if targetValue != "" {
                requiredInfoCount -= 1
                XCTAssertEqual(infoView.valueLabel.text, targetValue)
            }
        }
        XCTAssertEqual(0, requiredInfoCount)
    }
}
