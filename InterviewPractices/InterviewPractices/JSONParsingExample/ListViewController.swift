//
//  ViewController.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/18/20.
//

import UIKit

class ListViewController: UIViewController {
    
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView()
        
        self.view.backgroundColor = .red
        self.view.addSubViews([imageView])
    }
    
    override func viewDidLayoutSubviews() {
        imageView.setConstraintsToView(top: self.view, bottom: self.view, left: self.view, right: self.view)
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Use https://imgbb.com/ to create image urls
        let url = URL(string: "https://i.ibb.co/F0gNC4J/pexels-valeria-boltneva-1251208.jpg")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.imageView.image = UIImage(data: data!)
            }
        }
        imageView.backgroundColor = .blue
    }
}

