//
//  TestClasses.swift
//  InterviewPracticesTests
//
//  Created by Michael Ho on 11/24/20.
//

import UIKit

@testable import InterviewPractices
struct MockConstants {
    /**
     ImageLoadingExample
     */
    static let dummyURL = "https://abc.def.ghi.jkl"
    /**
     JSONParsingExample
     */
    enum JSON {
        case restaurants, cuisines(String?)
        
        var dummyData: [Any] {
            switch self {
            case .restaurants:
                return [
                    Restaurant(00, "name0", 1.0, "1,10", "123-123", "abc.123"),
                    Restaurant(11, "name0", 2.0, "1,10", "456-456", "abc.456"),
                    Restaurant(22, "name0", 3.0, "1,10", "789-789", "abc.789")
                ]
            default:
                return []
            }
        }
        
        var name: String {
            return "TestSample"
        }
        
        var directory: String {
            switch self {
            case .restaurants: return "restaurants"
            case .cuisines(let restaurantName): return "cuisines" + (restaurantName != nil ? ",\(restaurantName!)" : "")
            }
        }
    }
}

class MockJSONHelper: JSONHelper {
    static let sharedMock = MockJSONHelper()
    override init() {}
    
    override func getCurrentBundle() -> Bundle {
        return Bundle(for: JSONParsingExampleTests.self)
    }
}
// MARK: Mock URLSession
// Reference: https://www.swiftbysundell.com/articles/mocking-in-swift/
class MockURLSessionDataTask: URLSessionDataTask {
    var closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    /**
     Override the 'resume' method and call its closure instead of actually resuming any task.
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
        let data = self.data
        let error = self.error

        return MockURLSessionDataTask { completionHandler(data, nil, error) }
    }
}
// MARK: TestImageLoader
class MockImageLoader: ImageLoader {
    static let sharedMock = MockImageLoader()
    override init() {}
    var currentTask: MockURLSessionDataTask?
    
    override func setImageOnMainThread(_ imageView: UIImageView, _ image: UIImage) {
        imageView.image = image
    }
    
    override func getURLSessionInContext() -> URLSession {
        return MockURLSession.shared
    }
    
    override func getImageLoader() -> ImageLoader {
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

class MockListViewController: ListViewController {
    
    override func loadInitialData() {
        self.restaurantData = MockConstants.JSON.restaurants.dummyData as! [Restaurant]
    }
}
