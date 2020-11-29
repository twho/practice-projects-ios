//
//  InfoPairView.swift
//  PracticeProjects
//
//  Created by Amy Shih on 11/28/20.
//

import UIKit

class InfoPairView: UIStackView {
    // UI
    private var parameterLabel: UILabel!
    private var valueLabel: UILabel!
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        parameterLabel = UILabel(title: "", size: 16.0, color: .secondaryLabel)
        parameterLabel.textAlignment = .left
        valueLabel = UILabel(title: "", size: 16.0, color: .label)
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.textAlignment = .left
        self.axis = .horizontal
        self.distribution = .equalSpacing
        self.spacing = 10.0
        self.addArrangedSubview(parameterLabel)
        self.addArrangedSubview(valueLabel)
    }
    
    public convenience init(_ frame: CGRect = .zero, parameter: String, value: String) {
        self.init(frame: frame)
        configure(parameter: parameter, value: value)
    }
    
    public func configure(parameter: String, value: String) {
        parameterLabel.text = parameter
        valueLabel.text = value
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
