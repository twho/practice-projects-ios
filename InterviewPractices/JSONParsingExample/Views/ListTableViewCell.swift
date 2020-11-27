//
//  ListTableViewCell.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/19/20.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    // UI widgets
    var restaurantImageView: UIImageView!
    private(set) var title: UILabel!
    private(set) var rating: RatingView!
    private(set) var priceLabel: UILabel!
    private(set) var phoneLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.restaurantImageView = UIImageView()
        self.restaurantImageView.setCornerBorder()
        self.rating = RatingView()
        self.title = UILabel()
        self.title.font = .boldSystemFont(ofSize: self.title.font.pointSize)
        self.title.numberOfLines = 2
        self.priceLabel = UILabel()
        self.phoneLabel = UILabel()
        [title, priceLabel, phoneLabel].forEach {
            $0.adjustsFontSizeToFitWidth = true
        }
        self.addSubViews([restaurantImageView, title, rating, priceLabel, phoneLabel])
    }
    
    func loadDataToView(_ restaurant: Restaurant) {
        self.restaurantImageView.loadImage(restaurant.thumbnail, getImageLoaderInContext())
        self.title.text = restaurant.name
        self.rating.value = restaurant.rating
        self.priceLabel.text = "$\(restaurant.priceRange.components(separatedBy: ",")[0]) - \(restaurant.priceRange.components(separatedBy: ",")[1])"
        self.phoneLabel.text = "#\(restaurant.phoneNumber)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.frame.size.height
        let width = self.frame.size.width
        self.restaurantImageView.setConstraintsToView(top: self, tConst: 0.1 * height,
                                                      bottom: self, bConst: -0.1 * height,
                                                      left: self, lConst: 0.05 * width)
        self.restaurantImageView.widthAnchor.constraint(equalTo: restaurantImageView.heightAnchor).isActive = true
        self.title.setConstraintsToView(top: self, tConst: 0.1 * height, right: self, rConst: -0.05 * width)
        self.title.leftAnchor.constraint(equalTo: restaurantImageView.rightAnchor, constant: 0.05 * width).isActive = true
        self.rating.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0.05 * height).isActive = true
        self.rating.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        self.rating.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.05 * width).isActive = true
        self.rating.leftAnchor.constraint(equalTo: restaurantImageView.rightAnchor, constant: 0.05 * width).isActive = true
        self.priceLabel.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 0.05 * height).isActive = true
        self.priceLabel.setConstraintsToView(left: rating, right: rating)
        self.phoneLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0.05 * height).isActive = true
        self.phoneLabel.setConstraintsToView(left: rating, right: rating)
        self.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantImageView.cancelImageLoad(ImageLoader.shared)
        restaurantImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Override for testing
    func getImageLoaderInContext() -> ImageLoader {
        return ImageLoader.shared.getImageLoaderInContext()
    }
}
