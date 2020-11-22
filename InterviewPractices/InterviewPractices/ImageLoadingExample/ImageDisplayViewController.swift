//
//  ImageDisplayViewController.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/21/20.
//

import UIKit

class ImageDisplayViewController: UIViewController {
    // UI widgets
    private var collectionView: UICollectionView!
    // Constants
    private let collectionViewCellReuseIdentifier = "imageDisplayViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupTableView() {
        collectionView = UICollectionView()
        collectionView.register(ImageDisplayViewCell.self, forCellWithReuseIdentifier: collectionViewCellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubViews([collectionView])
    }
}

extension ImageDisplayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

class ImageDisplayViewCell: UICollectionViewCell {
    
}
