//
//  MHButton.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/22/20.
//

import UIKit

class MHButton: UIButton {
    private var bgColor: UIColor = .darkGray {
        didSet {
            self.backgroundColor = self.bgColor
        }
    }
    var example: Constants.Example = .jsonParser
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(frame: CGRect = .zero, example: Constants.Example) {
        self.init(text: example.title, textColor: .white, bgColor: .darkGray)
        self.example = example
    }
    
    public convenience init(frame: CGRect = .zero, icon: UIImage? = nil,
                text: String? = nil, textColor: UIColor? = .white, font: UIFont? = nil,
                bgColor: UIColor, cornerRadius: CGFloat = 12.0) {
        self.init(frame: frame)
        // Set the icon of the button
        if let icon = icon {
            self.setImage(icon)
        }
        // Set the title of the button
        if let text = text {
            self.setTitle(text)
            self.setTitleColor(textColor, for: .normal)
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        // Set button contents
        self.titleLabel?.font = font
        self.bgColor = bgColor
        self.backgroundColor = bgColor
        self.setBackgroundImage(UIImage(color: .lightGray), for: .disabled)
        self.setCornerBorder(cornerRadius: cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Touch
    // touchesBegan
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.backgroundColor = self.bgColor == UIColor.clear ? .lightGray : self.bgColor.getColorTint()
    }
    // touchesEnded
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.backgroundColor = self.bgColor
    }
    // touchesCancelled
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.backgroundColor = self.bgColor
    }
    // touchesMoved
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.backgroundColor = self.bgColor == UIColor.clear ? .lightGray : self.bgColor.getColorTint()
    }
}
