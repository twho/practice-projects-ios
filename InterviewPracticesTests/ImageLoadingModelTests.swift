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
        let image = UIImage(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0))!
        MockURLSession.sharedMock.data = image.pngData()
        let imageView = UIImageView()
        imageView.loadImage(MockConstants.dummyURL, MockImageLoader.sharedMock)
        // Check the place holder image
        XCTAssertEqual(imageView.image, #imageLiteral(resourceName: "ic_image_placeholder"))
        // Continue the loading task
        XCTAssertNotNil(MockImageLoader.sharedMock.currentTask)
        MockImageLoader.sharedMock.currentTask!.resume()
        // Check the loaded image
        XCTAssertNotNil(imageView.image?.pngData())
        XCTAssertTrue(imageView.image!.isContentEqualTo(image))
    }
}
