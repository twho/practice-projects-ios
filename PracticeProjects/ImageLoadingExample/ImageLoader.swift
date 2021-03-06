//
//  ImageLoader.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/20/20.
// 
//  Reference: https://www.donnywals.com/efficiently-loading-images-in-table-views-and-collection-views/
//  Reference: https://www.raywenderlich.com/5370-grand-central-dispatch-tutorial-for-swift-4-part-1-2
//  Reference: https://www.raywenderlich.com/5371-grand-central-dispatch-tutorial-for-swift-4-part-2-2
//

import UIKit

class ImageLoader: NSObject {
    // Singleton
    static let shared = ImageLoader()
    override init() {}
    // Thread safe operations. These two properties have to be PRIVATE.
    private var unsafeImages = [URL: UIImage]()
    private let concurrentImageQueue =
        DispatchQueue(
            label: "com.michaelho.PracticeProjects.ImageLoader",
            attributes: .concurrent
        )
    // Local cache accessible to all
    var storedImages: [URL: UIImage] {
        var imagesCopy = [URL: UIImage]()
        concurrentImageQueue.sync {
            imagesCopy = self.unsafeImages
        }
        return imagesCopy
    }
    // Testables properties
    var uuidMap = [UIImageView : UUID]()
    var queuedTasks = [UUID : URLSessionDataTask]()
    /**
     Load image from URL resource.
     
     - Parameter url:       The url location that stores the image.
     - Parameter imageView: The image view to load image to and display image.
     */
    func load(_ url: URL, for imageView: UIImageView) {
        // Show activity indicator before loading is done.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        imageView.addSubViews([activityIndicator])
        imageView.centerSubView(activityIndicator)
        // The dataTask in loadImage method is asynchronous.
        let token = self.loadImage(url) { [weak self] result in
            guard let self = self else { return }
            defer { self.uuidMap[imageView] = nil } // Clean up no matter what
            do {
                let image = try result.get()
                self.getGCDHelperInContext().runOnMainThread {
                    activityIndicator.removeFromSuperview()
                    imageView.image = image
                }
            } catch {
                print(self.logtag + error.localizedDescription)
            }
        }
        if let token = token {
            // Update local storage
            self.uuidMap[imageView] = token
        }
    }
    /**
     Cancel the loading task. Since the loading tasks are asynchronous, we have to cancel it properly if
     they are no longer needed. This way, they don't queue up and make the app slow.
     
     - Parameter imageView: The image view that is no longer needed.
     */
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            self.cancelLoad(uuid)
            uuidMap[imageView] = nil
        }
    }
    /**
     The complete image loading task that includes error handling and local storage management.
     
     - Parameter url:       The url location that stores the image.
     - Parameter imageView: The image view to load image to and display image.
     
     - Returns: An uuid represents the current loading task.
     */
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        // If the image is loaded before, just return it from local storage.
        if let image = storedImages[url] {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        // The dataTask is asynchronous
        let task = getURLSessionInContext().dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            defer { self.queuedTasks[uuid] = nil }
            
            if let data = data, let image = UIImage(data: data) {
                if let responseURL = response?.url {
                    self.concurrentImageQueue.async(flags: .barrier) { [weak self] in
                        // Write data in barrier queue to prevent
                        self?.unsafeImages[responseURL] = image
                    }
                }
                completion(.success(image))
                return
            }
            
            // without an image or an error, we'll just ignore this for now
            guard let error = error else { return }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
            // the request was cancelled, no need to call the callback
        }
        resumeTask(task, uuid)
        queuedTasks[uuid] = task
        return uuid
    }
    /**
     Cancel the loading task.
     
     - Parameter uuid: The uuid of the task to be canceled.
     */
    private func cancelLoad(_ uuid: UUID) {
        queuedTasks[uuid]?.cancel()
        queuedTasks[uuid] = nil
    }
    // MARK: Test Functions
    /**
     Method to provide GCD helper based on the current context, used for test override.
     
     - Returns: An GCD helper used in current context.
     */
    func getGCDHelperInContext() -> GCDHelper {
        return GCDHelper.shared
    }
    /**
     Method to provide right URL session based on the current context, used for test override.
     
     - Returns: An URL session used in current context.
     */
    func getURLSessionInContext() -> URLSession {
        return URLSession.shared
    }
    /**
     Used for test override.
     
     - Returns: The correct image loader to be used in the environment.
     */
    func getImageLoaderInContext() -> ImageLoader {
        return ImageLoader.shared
    }
    /**
     Method to resume task and record it locally.
     
     - Parameter task: Current task.
     - Parameter uuid: The uuid used to mark the current task.
     */
    func resumeTask(_ task: URLSessionDataTask, _ uuid: UUID) {
        task.resume()
    }
    /**
     Clean up all storage.
     */
    func cleanup() {
        self.unsafeImages.removeAll()
        self.queuedTasks.removeAll()
        self.uuidMap.removeAll()
    }
}

extension UIImageView {
    /**
     Load image into current image view.
     
     - Parameter urlString: The image URL as a String.
     - Parameter loader:    The utility loader used to load image.
     
     Reference: Use https://imgbb.com/ to create image urls.
     */
    func loadImage(_ urlString: String, _ loader: ImageLoader) {
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL string.")
            return
        }
        loader.load(url, for: self)
    }
    /**
     Cancel image loading task.
     
     - Parameter loader: The utility loader used to load image.
     */
    func cancelImageLoad(_ loader: ImageLoader) {
        loader.cancel(for: self)
    }
}
