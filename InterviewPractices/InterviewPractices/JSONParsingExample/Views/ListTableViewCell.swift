//
//  ListTableViewCell.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/19/20.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    // UI widgets
    private var restaurantImageView: UIImageView!
    private var title: UILabel!
    private var rating: RatingView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.restaurantImageView = UIImageView()
        self.restaurantImageView.setCornerBorder()
        self.title = UILabel()
        self.title.font = .boldSystemFont(ofSize: self.title.font.pointSize)
        self.title.numberOfLines = 2
        self.title.adjustsFontSizeToFitWidth = true
        self.rating = RatingView()
        self.addSubViews([restaurantImageView, title, rating])
    }
    
    func loadDataToView(_ restaurant: Restaurant) {
        self.restaurantImageView.loadImage(restaurant.thumbnail)
        self.title.text = restaurant.name
        self.rating.value = restaurant.rating
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.frame.size.height
        let width = self.frame.size.width
        self.restaurantImageView.setConstraintsToView(top: self, tConst: 0.1 * height,
                                                      bottom: self, bConst: -0.1 * height,
                                                      left: self, lConst: 0.05 * width)
        self.restaurantImageView.widthAnchor.constraint(equalTo: self.restaurantImageView.heightAnchor).isActive = true
        self.title.setConstraintsToView(top: self, tConst: 0.1 * height, right: self, rConst: -0.05 * width)
        self.title.leftAnchor.constraint(equalTo: restaurantImageView.rightAnchor, constant: 0.05 * width).isActive = true
        self.rating.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0.05 * height).isActive = true
        self.rating.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        self.rating.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.05 * width).isActive = true
        self.rating.leftAnchor.constraint(equalTo: self.restaurantImageView.rightAnchor, constant: 0.05 * width).isActive = true
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
