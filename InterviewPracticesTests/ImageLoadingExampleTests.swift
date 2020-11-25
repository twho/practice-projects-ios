//
//  ImageLoadingExampleTests.swift
//  InterviewPracticesTests
//
//  Created by Michael Ho on 11/24/20.
//

import XCTest

@testable import InterviewPractices
class ImageLoadingExampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSingleImageLoading() {
        let imageView = UIImageView()
        imageView.loadImage(TestConstants.singleImage, TestImageLoader.sharedTestLoader)
        // Check the place holder image
        XCTAssertEqual(imageView.image, #imageLiteral(resourceName: "ic_image_placeholder"))
        XCTAssertNotNil(TestImageLoader.sharedTestLoader.currentTask)
        let task = TestImageLoader.sharedTestLoader.currentTask!
        task.resume()
        // Check the loaded image
        XCTAssertEqual(imageView.image?.getPixelColor(CGPoint(x: 0, y: 0)), UIColor(red: 0, green: 0, blue: 0, alpha: 1.0))
    }
}
