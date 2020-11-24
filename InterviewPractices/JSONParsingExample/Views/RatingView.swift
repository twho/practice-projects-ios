//
//  RatingView.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/21/20.
//

import UIKit

class RatingView: UIView {
    
    // UI widgets
    private var starView: StarView!
    private var title: UILabel!
    
    var value: Double = 0.0 {
        didSet {
            title.text = String(value)
            starView.value = value
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        starView = StarView()
        title = UILabel()
        title.adjustsFontSizeToFitWidth = true
        self.addSubViews([starView, title])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.setConstraintsToView(top: self, bottom: self, left: self)
        starView.setConstraintsToView(top: self, bottom: self)
        starView.widthAnchor.constraint(equalTo: starView.heightAnchor, multiplier: 5).isActive = true
        starView.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 0.05 * self.frame.width).isActive = true
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StarView: UIView {
    // Resource
    private static let filledStar = #imageLiteral(resourceName: "ic_star_filled").colored(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
    private static let outlineStar = #imageLiteral(resourceName: "ic_star_outline").colored(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
    // UI
    private var stack: UIStackView!
    // Constants
    private let logtag = "[StarView] "
    
    var value: Double = 0.0 {
        didSet {
            create(value)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stack = UIStackView(arrangedSubviews: nil, axis: .horizontal, distribution: .fillEqually, spacing: 0.0)
        self.addSubViews([stack])
    }
    
    private func create(_ rating: Double) {
        guard rating < 5 else { return }
        stack.removeAllSubviews()
        var remaining = rating
        var count = 0
        while remaining - 1 > 0 {
            let view = UIImageView(image: StarView.filledStar)
            view.contentMode = .scaleAspectFit
            stack.addArrangedSubview(view)
            remaining -= 1
            count += 1
        }
        if remaining > 0 {
            stack.addArrangedSubview(createPartialRating(remaining))
            count += 1
        }
        if count < 5 {
            for _ in count..<5 {
                stack.addArrangedSubview(UIImageView(image: StarView.outlineStar))
            }
        }
    }
    
    private func createPartialRating(_ fractional: Double) -> UIImageView {
        let height = self.frame.height
        // Set up outline star view as background.
        let outline = UIImageView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        outline.image = StarView.outlineStar
        // Set up the filled star view.
        let filled = UIImageView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        filled.image = StarView.filledStar
        // Mask the view.
        let layer = CAShapeLayer()
        let path = CGPath(rect: CGRect(x: 0, y: 0, width: CGFloat(fractional) * height, height: height), transform: nil)
        layer.path = path
        filled.layer.mask = layer
        // Combine two views.
        outline.addSubview(filled)
        return outline
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stack.setConstraintsToView(top: self, bottom: self, left: self, right: self)
        self.layoutIfNeeded()
        if self.frame.size.width / self.frame.size.height != 5.0 {
            print("\(logtag) It is required to set star view in width : height == 5 : 1")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
