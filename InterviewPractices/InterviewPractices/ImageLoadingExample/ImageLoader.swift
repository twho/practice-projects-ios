//
//  ImageLoader.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/20/20.
//  Reference: https://www.donnywals.com/efficiently-loading-images-in-table-views-and-collection-views/
//

import UIKit

class ImageLoader {
    // Singleton
    static let shared = ImageLoader()
    private init() {}
    // Private properties
    private var loadedImages = [URL: UIImage]()
    private var uuidMap = [UIImageView : UUID]()
    private var queuedTasks = [UUID : URLSessionDataTask]()
    private let logtag = "ImageLoader: "
    /**
     Load image from URL resource.
     
     - Parameter url:       The url location that stores the image.
     - Parameter imageView: The image view to load image to and display image.
     */
    func load(_ url: URL, for imageView: UIImageView) {
        // The dataTask in loadImage method is asynchronous.
        let token = self.loadImage(url) { result in
            defer { self.uuidMap[imageView] = nil } // Clean up no matter what
            do {
                let image = try result.get()
                DispatchQueue.main.async {
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
     
     - Parameter: The image view that is no longer needed.
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
     
     - Returns: An uuid 
     */
    private func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        // If the image is loaded before, just return it from local storage.
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        // The dataTask is asynchronous
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.queuedTasks[uuid] = nil }
            
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages[url] = image
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
        task.resume()
        queuedTasks[uuid] = task
        return uuid
    }
    
    private func cancelLoad(_ uuid: UUID) {
        queuedTasks[uuid]?.cancel()
        queuedTasks[uuid] = nil
    }
}

extension UIImageView {
    /**
     Load image into current image view.
     
     - Parameter urlString: The image URL as a String.
     
     Reference: Use https://imgbb.com/ to create image urls.
     */
    func loadImage(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string.")
            return
        }
        ImageLoader.shared.load(url, for: self)
    }
    /**
     Cancel image loading task.
     */
    func cancelImageLoad() {
        ImageLoader.shared.cancel(for: self)
    }
}
