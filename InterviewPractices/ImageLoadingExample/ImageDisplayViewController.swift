//
//  ImageDisplayViewController.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/21/20.
//

import UIKit

// implement state clear loading by raywanderich

class ImageDisplayViewController: UIViewController {
    // UI widgets
    var collectionView: UICollectionView!
    private(set) var navbar: UINavigationBar!
    // Data
    var isAnimating = false
    var restaurantData: [Restaurant] = [] {
        didSet {
            if self.isViewVisible, !self.isAnimating {
                self.runInAnimation { [weak self] in
                    guard let self = self else { return }
                    self.collectionView.reloadData()
                    self.isAnimating = true
                } completion: { _ in
                    self.isAnimating = false
                }
            } else {
                self.collectionView.reloadData()
            }
        }
    }
    // Constants
    private let numberOfItemsInRow = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func loadView() {
        super.loadView()
        self.navbar = self.addNavigationBar(title: Constants.Example.imageLoader.title,
                                            rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close").colored(.white), style: .done, target: self, action: #selector(self.backToPreviousVC)))
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        (flowLayout.minimumLineSpacing, flowLayout.minimumInteritemSpacing) = (0, 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ImageDisplayViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        (collectionView.delegate, collectionView.dataSource) = (self, self)
        collectionView.backgroundColor = .lightGray
        collectionView.canCancelContentTouches = false
        self.view.addSubViews([collectionView])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        collectionView.setConstraintsToView(bottom: self.view, left: self.view, right: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadInitialData()
    }
    // Override for testing
    func loadInitialData() {
        restaurantData = JSONHelper.shared.readLocalJSONFile(Constants.JSON.restaurants.name, Restaurant.self, Constants.JSON.restaurants.directory)
    }
}

extension ImageDisplayViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return restaurantData.count / numberOfItemsInRow
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInRow
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = .lightGray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = .white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / CGFloat(numberOfItemsInRow)
        return CGSize(width: width, height: 1.2 * width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        if let displayCell = cell as? ImageDisplayViewCell {
            let dataIndex = indexPath.section * numberOfItemsInRow + (indexPath.item)
            displayCell.restaurantImageView.loadImage(restaurantData[dataIndex].thumbnail, ImageLoader.shared)
            displayCell.title.text = restaurantData[dataIndex].name
        }
        return cell
    }
}

class ImageDisplayViewCell: UICollectionViewCell {
    // UI widgets
    var restaurantImageView: UIImageView!
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        restaurantImageView = UIImageView()
        restaurantImageView.setCornerBorder()
        title = UILabel()
        title.font = .systemFont(ofSize: 12.0)
        title.minimumScaleFactor = 0.8
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        self.addSubViews([restaurantImageView, title])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.frame.size.height
        let width = self.frame.size.width
        self.restaurantImageView.setConstraintsToView(top: self, tConst: 0.1 * height, left: self, lConst: 0.1 * width, right: self, rConst: -0.1 * width)
        self.restaurantImageView.setSquareBasedOnWidth()
        self.title.topAnchor.constraint(equalTo: self.restaurantImageView.bottomAnchor, constant: 0.05 * height).isActive = true
        self.title.setConstraintsToView(bottom: self, bConst: -0.05 * height, left: restaurantImageView, right: restaurantImageView)
        self.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantImageView.image = nil
        restaurantImageView.cancelImageLoad(ImageLoader.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
