//
//  ImageLoadingExampleTests.swift
//  InterviewPracticesTests
//
//  Created by Michael Ho on 11/24/20.
//

import XCTest

@testable import InterviewPractices
class ImageDisplayModelTests: XCTestCase {
    private let singleImage = UIImage(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0))!

    override func setUpWithError() throws {
        MockURLSession.sharedMock.data = singleImage.pngData()
    }

    override func tearDownWithError() throws {
        MockURLSession.sharedMock.data = nil
        MockImageLoader.sharedMock.storedImages.removeAll()
        MockImageLoader.sharedMock.queuedTasks.removeAll()
    }
    
    func testImageLoaderInContext() {
        // The image loader used in normal app environment (should be ImageLoader, not MockImageLoader)
        XCTAssertFalse(MockImageLoader.shared.getImageLoaderInContext() is MockImageLoader)
        // The image loader used in test environment
        XCTAssertTrue(MockImageLoader.sharedMock.getImageLoaderInContext() is MockImageLoader)
    }
    
    func testSingleImageLoading() {
        let imageView = UIImageView()
        imageView.loadImage(MockConstants.dummyURL, MockImageLoader.sharedMock)
        // Check the place holder image
        XCTAssertEqual(imageView.image, #imageLiteral(resourceName: "ic_image_placeholder"))
        // Continue the loading task
        XCTAssertNotNil(MockImageLoader.sharedMock.currentTask)
        MockImageLoader.sharedMock.currentTask!.resume()
        // Check the loaded image
        XCTAssertNotNil(imageView.image?.pngData())
        XCTAssertTrue(imageView.image!.isContentEqualTo(singleImage))
    }
    
    func testImageLoadedIntoLocalStorage() {
        let image = UIImage(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0))!
        MockURLSession.sharedMock.data = image.pngData()
        let imageView = UIImageView()
        imageView.loadImage(MockConstants.dummyURL, MockImageLoader.sharedMock)
        MockImageLoader.sharedMock.currentTask!.resume()
        // Check the existence of the image in local data storage.
        let url = URL(string: MockConstants.dummyURL)!
        XCTAssertNotNil(MockImageLoader.sharedMock.storedImages[url])
        XCTAssertTrue(MockImageLoader.sharedMock.storedImages[url]!.isContentEqualTo(singleImage))
    }
}
