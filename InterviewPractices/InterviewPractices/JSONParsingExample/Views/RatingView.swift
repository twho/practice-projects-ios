//
//  RatingView.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/21/20.
//

import UIKit

class RatingView: UIView {
    // UI widgets
    private var stack: UIStackView!
    
    public convenience init(_ rating: String) {
        self.init()
        stack = UIStackView(arrangedSubviews: nil, axis: .horizontal, distribution: .fillEqually, spacing: 5.0)
    }
    
    private func create(_ rating: Double) {
        var remaining = rating
        var count = 0
        while remaining - 1 > 0 {
            stack.addArrangedSubview(UIImageView(image: #imageLiteral(resourceName: "icons8-multiply-24")))
            remaining -= 1
            count += 1
        }
        self.addSubViews([stack])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stack.setConstraintsToView(top: self, bottom: self, left: self, right: self)
    }
}
