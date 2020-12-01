//
//  ImageDisplayViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/21/20.
//

import UIKit

class ImageDisplayViewController: UIViewController {
    // UI widgets
    var collectionView: UICollectionView!
    private(set) var navbar: UINavigationBar!
    // Properties for state driven collectionView
    private(set) var stackView: UIStackView!
    private(set) var activityIndicator: UIActivityIndicatorView!
    private(set) var loadingView: UIView!
    private(set) var emptyView: UIView!
    private(set) var errorView: UIView!
    private(set) var errorLabel: UILabel!
    // Data
    var isAnimating = false
    var state = CollectionState.loading {
        didSet {
            // Add the delay intentionally to show loading state
            getGCDHelperInContext().runOnMainThreadAfter(delay: 2.0) { [weak self] in
                guard let self = self else { return }
                self.displayStateView()
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
    }
    // Constants
    private let numberOfItemsInRow = 3
    private let stateViewHeight: CGFloat = 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        navbar = self.addNavigationBar(title: Constants.Example.imageLoader.title,
                                       rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close"), style: .done, target: self, action: #selector(self.backToPreviousVC)))
        setupCollectionView()
        setupStateViews()
    }
    /**
     Set up collectionView.
     */
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        (flowLayout.minimumLineSpacing, flowLayout.minimumInteritemSpacing) = (0, 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ImageDisplayViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        (collectionView.delegate, collectionView.dataSource) = (self, self)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.canCancelContentTouches = false
        collectionView.allowsMultipleSelection = false
        self.view.addSubViews([collectionView])
    }
    /**
     Setup for state driven collectionView. (This part is not must-have for the example)
     */
    private func setupStateViews() {
        // Loading view
        activityIndicator = UIActivityIndicatorView()
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.stateViewHeight))
        loadingView.addSubViews([activityIndicator])
        loadingView.centerSubView(activityIndicator)
        // Empty view
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.stateViewHeight))
        let noResultLabel = UILabel(title: "No results! Try searching for something else.", size: 17.0, bold: false, color: .label)
        emptyView.addSubViews([noResultLabel])
        noResultLabel.setConstraintsToView(left: emptyView, right: emptyView)
        emptyView.centerSubView(noResultLabel)
        // Error view
        errorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.stateViewHeight))
        errorLabel = UILabel(title: "There is an error.", size: 17.0, bold: false, color: .label)
        errorView.addSubViews([errorLabel])
        errorLabel.setConstraintsToView(left: errorView, right: errorView)
        errorView.centerSubView(errorLabel)
        [errorLabel, noResultLabel].forEach({
            $0!.numberOfLines = 2
        })
        stackView = UIStackView(arrangedSubviews: [loadingView, emptyView, errorView], axis: .vertical, distribution: .fillEqually, spacing: 0.0)
        self.view.addSubViews([stackView])
        self.displayStateView()
    }
    
    func displayStateView() {
        stackView.arrangedSubviews.forEach {
            $0.isHidden = true
        }
        switch state {
        case .error(let error):
            errorLabel.text = error.localizedDescription
            errorView.isHidden = false
        case .loading:
            activityIndicator.startAnimating()
            loadingView.isHidden = false
        case .empty:
            emptyView.isHidden = false
        case .populated:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        collectionView.setConstraintsToView(bottom: self.view, left: self.view, right: self.view)
        stackView.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        stackView.setConstraintsToView(left: self.view, right: self.view)
        stackView.setHeightConstraint(self.stateViewHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadInitialData()
    }
    // Override for testing
    /**
     Load initial data to display.
     */
    func loadInitialData() {
        JSONHelper.shared.readLocalJSONFile(Constants.JSON.restaurants.name, Restaurant.self, Constants.JSON.restaurants.directory) { [weak self] result in
            guard let self = self else { return }
            do {
                let data = try result.get()
                self.state = .populated(data)
            } catch {
                self.state = .error(error)
            }
        }
    }
    /**
     Method to provide GCD helper based on the current context, used for test override.
     
     - Returns: An GCD helper used in current context.
     */
    func getGCDHelperInContext() -> GCDHelper {
        return GCDHelper.shared
    }
}

extension ImageDisplayViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return max(1, state.elements.count / numberOfItemsInRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(numberOfItemsInRow, state.elements.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / CGFloat(numberOfItemsInRow)
        return CGSize(width: width, height: 1.2 * width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        if let displayCell = cell as? ImageDisplayViewCell, let restaurants = state.elements as? [Restaurant] {
            let dataIndex = indexPath.section * numberOfItemsInRow + (indexPath.item)
            displayCell.restaurantImageView.loadImage(restaurants[dataIndex].thumbnail, ImageLoader.shared)
            displayCell.title.text = restaurants[dataIndex].name
        }
        return cell
    }
}

class ImageDisplayViewCell: UICollectionViewCell {
    // UI widgets
    var restaurantImageView: UIImageView!
    var title: UILabel!
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .systemFill : .systemBackground
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
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
        self.restaurantImageView.setSquareUseWidthReference()
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
