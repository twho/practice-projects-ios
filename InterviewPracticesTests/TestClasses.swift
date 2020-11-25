//
//  TestClasses.swift
//  InterviewPracticesTests
//
//  Created by Michael Ho on 11/24/20.
//

import UIKit

@testable import InterviewPractices
struct TestConstants {
    /**
     ImageLoadingExample
     */
    static let singleImage = "https://dummyimage.com/600x400/000000/000000"
    /**
     JSONParsingExample
     */
    enum JSON {
        case restaurants, cuisines
        
        var name: String {
            return "TestSample"
        }
        
        var directory: String {
            switch self {
            case .restaurants: return "restaurants"
            case .cuisines: return "cuisines"
            }
        }
    }
}

class TestJSONHelper: JSONHelper {
    static let sharedTestHelper = TestJSONHelper()
    override init() {}
    
    override func getCurrentBundle() -> Bundle {
        return Bundle(for: JSONParsingExampleTests.self)
    }
}
// MARK: Mock  URLSession
// Reference: https://www.swiftbysundell.com/articles/mocking-in-swift/
class TestURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    
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

class TestURLSession: URLSession {
    override class var shared: URLSession {
        return TestURLSession()
    }
    typealias Completion = (Data?, URLResponse?, Error?) -> Void
    var data: Data?
    var error: Error?
    
    private override init() {}

    override func dataTask(with url: URL, completionHandler: @escaping Completion) -> URLSessionDataTask {
        let data = self.data
        let error = self.error

        return TestURLSessionDataTask {
            completionHandler(data, nil, error)
        }
    }
}
// MARK: TestImageLoader
class TestImageLoader: ImageLoader {
    static let sharedTestLoader = TestImageLoader()
    override init() {}
    var currentTask: URLSessionDataTask?
    
    override func getURLSessionInContext() -> URLSession {
        return TestURLSession.shared
    }
    
    override func getImageLoader() -> ImageLoader {
        return TestImageLoader.sharedTestLoader
    }
    
    override func resumeTask(_ task: URLSessionDataTask, _ uuid: UUID) {
        // task.resume() will be called in the tests.
        currentTask = task
        queuedTasks[uuid] = task
    }
}
