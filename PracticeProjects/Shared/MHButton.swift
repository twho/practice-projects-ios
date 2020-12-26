//
//  MHButton.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/22/20.
//

import UIKit

class MHButton: UIButton {
    private var bgColor: UIColor = .systemFill {
        didSet {
            self.backgroundColor = self.bgColor
        }
    }
    var example: Constants.Example = .jsonDecoder
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(frame: CGRect = .zero, example: Constants.Example) {
        self.init(text: example.title, textColor: .label, bgColor: .systemFill)
        self.example = example
    }
    
    public convenience init(frame: CGRect = .zero, icon: UIImage? = nil,
                            text: String? = nil, textColor: UIColor? = .label, font: UIFont? = nil,
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
        self.setBackgroundImage(UIImage(color: .tertiarySystemFill), for: .disabled)
        self.setCornerBorder(cornerRadius: cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Touch
    // touchesBegan
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.backgroundColor = self.bgColor == UIColor.clear ? .systemFill : self.bgColor.getColorTint()
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
        self.backgroundColor = self.bgColor == UIColor.clear ? .systemFill : self.bgColor.getColorTint()
    }
}
