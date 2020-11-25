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
        let imageData = UIImage(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0))?.pngData()
        TestURLSession.sharedTestSession.data = imageData
        let imageView = UIImageView()
        imageView.loadImage(TestConstants.dummyURL, TestImageLoader.sharedTestLoader)
        // Check the place holder image
        XCTAssertEqual(imageView.image, #imageLiteral(resourceName: "ic_image_placeholder"))
        // Continue the loading task
        XCTAssertNotNil(TestImageLoader.sharedTestLoader.currentTask)
        TestImageLoader.sharedTestLoader.currentTask!.resume()
        // Check the loaded image
        XCTAssertNotNil(imageView.image?.pngData())
        XCTAssertEqual(imageView.image?.pngData(), imageData)
    }
}
