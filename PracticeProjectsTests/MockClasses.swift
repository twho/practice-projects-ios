//
//  MockClasses.swift
//  PracticeProjectsTests
//
//  Created by Michael Ho on 11/24/20.
//

import UIKit

@testable import PracticeProjects
struct MockConstants {
    /**
     ImageLoadingExample
     */
    static let dummyURL = "https://abc.def.ghi.jkl"
    /**
     JSONParsingExample
     */
    enum TestJSON: Equatable {
        case shared, restaurants, meals(String?), people, companies
        
        var dummyImageURLs: [String] {
            return [
                "https://dummyimage.com/0",
                "https://dummyimage.com/1",
                "https://dummyimage.com/2"
            ]
        }
        
        var dummyData: [Any] {
            switch self {
            case .restaurants:
                return [
                    Restaurant(00, "name0", 1.0, "1,10", "123-123", dummyImageURLs[0]),
                    Restaurant(11, "name1", 2.0, "2,20", "456-456", dummyImageURLs[1]),
                    Restaurant(22, "name2", 3.0, "3,30", "789-789", dummyImageURLs[2])
                ]
            case .meals(_):
                return [
                    Meal(101, "meal001", 0.5, "cat01"),
                    Meal(202, "meal002", 0.6, "cat02"),
                    Meal(303, "meal003", 0.7, "cat03"),
                    Meal(404, "meal004", 0.8, "cat01"),
                    Meal(505, "meal005", 0.9, "cat01"),
                    Meal(606, "meal006", 1.5, "cat01"),
                    Meal(707, "meal007", 1.6, "cat02"),
                    Meal(808, "meal008", 1.7, "cat02"),
                    Meal(909, "meal009", 1.8, "cat03")
                ]
            case .people, .companies:
                let companies = [
                    Company("Company101", "Company101 is good", "Company101 makes money"),
                    Company("Company202", "Company202 is good", "Company202 makes money"),
                    Company("Company303", "Company303 is good", "Company303 makes money")
                ]
                let people = [
                    People(101, "name01", "user01", "user01@mail.com", "123-456-78901", companies[0], "user01.com"),
                    People(202, "name02", "user02", "user02@mail.com", "123-456-78902", companies[1], "user02.com"),
                    People(303, "name03", "user03", "user03@mail.com", "123-456-78903", companies[2], "user03.com")
                ]
                return self == TestJSON.people ? people : companies
            default:
                return []
            }
        }
        
        var dummyDataMap: [URL : Data] {
            let map = [
                URL(string: dummyImageURLs[0])! : UIImage(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0))!.pngData()!,
                URL(string: dummyImageURLs[1])! : UIImage(color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))!.pngData()!,
                URL(string: dummyImageURLs[2])! : UIImage(color: UIColor(red: 2, green: 2, blue: 2, alpha: 1.0))!.pngData()!
            ]
            return map
        }
        
        var name: String {
            return "TestSample"
        }
        
        var directory: String {
            switch self {
            case .restaurants: return "restaurants"
            case .meals(let restaurantName): return "meals" + (restaurantName != nil ? ",\(restaurantName!)" : "")
            case .people: return "people"
            default: return ""
            }
        }
    }
}
// MARK: - Helpers and Utilities
class MockJSONHelper: JSONHelper {
    static let sharedMock = MockJSONHelper()
    override init() {}
    
    override func getCurrentBundle() -> Bundle {
        return Bundle(for: JSONParsingExampleTests.self)
    }
}
// Reference: https://www.swiftbysundell.com/articles/mocking-in-swift/
class MockURLSessionDataTask: URLSessionDataTask {
    var closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    /**
     Override the resume method and call its closure instead of actually resuming any task.
     */
    override func resume() {
        closure()
    }
}

class MockURLSession: URLSession {
    static let sharedMock = MockURLSession()
    override class var shared: URLSession { return sharedMock }
    typealias Completion = (Data?, URLResponse?, Error?) -> Void
    var data: Data?
    var error: Error?
    
    private override init() {}

    override func dataTask(with url: URL, completionHandler: @escaping Completion) -> URLSessionDataTask {
        let error = self.error
        var data = self.data
        if let validData = MockConstants.TestJSON.shared.dummyDataMap[url] {
            data = validData
        }
        return MockURLSessionDataTask { completionHandler(data, nil, error) }
    }
}

class MockImageLoader: ImageLoader {
    static let sharedMock = MockImageLoader()
    override init() {}
    var currentTask: MockURLSessionDataTask?
    
    override func getGCDHelperInContext() -> GCDHelper {
        return MockGCDHelper.sharedMock
    }
    
    override func getURLSessionInContext() -> URLSession {
        return MockURLSession.shared
    }
    
    override func getImageLoaderInContext() -> ImageLoader {
        return MockImageLoader.sharedMock
    }
    
    override func resumeTask(_ task: URLSessionDataTask, _ uuid: UUID) {
        // task.resume() will be called in the tests.
        guard let testTask = task as? MockURLSessionDataTask else {
            preconditionFailure("Need to use TestURLSessionDataTask in test environment.")
        }
        currentTask = testTask
        queuedTasks[uuid] = task
    }
}

class MockGCDHelper: GCDHelper {
    static let sharedMock = MockGCDHelper()
    override init() {}
    private var taskQueue = [Block]()
    
    override func runOnMainThread(_ block: @escaping Block) {
        taskQueue.append(block)
    }
    
    override func runOnMainThreadAfter(delay: Double, _ block: @escaping Block) {
        taskQueue.append(block)
    }
    
    func dequeueAndRunTask() {
        if taskQueue.count > 0 {
            let block = taskQueue.removeFirst()
            block()
        }
    }
    
    func runAllTasksInQueue() {
        while !taskQueue.isEmpty {
            let first = taskQueue.removeFirst()
            first()
        }
    }
    
    func removeAllTasks() {
        taskQueue.removeAll()
    }
}

// MARK: View Controllers
@objc(MockAppDelegate)
class MockAppDelegate: UIResponder, UIApplicationDelegate {}

class MockListViewController: ListViewController {
    
    override func loadInitialData() {
        // Use test date resources since we have a model test for JSON reading capabilities.
        self.restaurantData = MockConstants.TestJSON.restaurants.dummyData as! [Restaurant]
    }
    
    override func registerTableViewCell() {
        tableView.register(MockListTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
}

class MockListDetailViewController: ListDetailViewController {
    
    override func loadInitialData() {
        // Use test date resources since we have a model test for JSON reading capabilities.
        self.mealData = MockConstants.TestJSON.meals(nil).dummyData as! [Meal]
    }
}

class MockListTableViewCell: ListTableViewCell {
    
    override func getImageLoaderInContext() -> ImageLoader {
        return MockImageLoader.sharedMock
    }
}

class MockImageDisplayViewController: ImageDisplayViewController {
    var testData: [Restaurant] {
        return self.state.elements as? [Restaurant] ?? []
    }
    
    override func loadInitialData() {
        // Use test date resources since we have a model test for JSON reading capabilities.
        let data = MockConstants.TestJSON.restaurants.dummyData as! [Restaurant]
        self.state = .populated(data)
    }
    
    override func getGCDHelperInContext() -> GCDHelper {
        return MockGCDHelper.sharedMock
    }
}

class MockContactsViewController: ContactsViewController {
    var testData: [People] {
        return self.state.elements as? [People] ?? []
    }
    
    override func loadInitialData() {
        // Use test date and let the model tests to check JSON reading from API.
        let data = MockConstants.TestJSON.people.dummyData as! [People]
        self.peopleData = data
        self.state = .populated(data)
    }
    
    override func getGCDHelperInContext() -> GCDHelper {
        return MockGCDHelper.sharedMock
    }
}