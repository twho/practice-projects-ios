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
    private var collectionView: UICollectionView!
    private var navbar: UINavigationBar!
    // Data
    private var restaurantData = [Restaurant]()
    // Constants
    private let collectionViewCellReuseIdentifier = "imageDisplayViewCell"
    private let JSONFile = (name: "RestaurantSamples", directory: "restaurants")
    private let numberOfItemsInRow = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantData = JSONHelper.shared.readLocalJSONFile(JSONFile.name, Restaurant.self, JSONFile.directory)
        setupCollectionView()
    }
    
    override func loadView() {
        super.loadView()
        self.navbar = self.addNavigationBar(title: Example.imageLoader.title,
                                            rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close").colored(.white), style: .done, target: self, action: #selector(self.backToPreviousVC)))
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        (flowLayout.minimumLineSpacing, flowLayout.minimumInteritemSpacing) = (0, 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ImageDisplayViewCell.self, forCellWithReuseIdentifier: collectionViewCellReuseIdentifier)
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
        self.collectionView.reloadData()
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
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifier, for: indexPath)
        if let displayCell = cell as? ImageDisplayViewCell {
            let dataIndex = indexPath.section * numberOfItemsInRow + (indexPath.item)
            displayCell.restaurantImageView.loadImage(restaurantData[dataIndex].thumbnail)
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
        restaurantImageView.cancelImageLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
