//
//  DialogViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/15/21.
//

import UIKit

class DialogViewController: UIViewController {
    private(set) var realBackground: UIView!
    private(set) var closeButton: UIButton!
    var titleLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        realBackground = UIView(color: .secondarySystemBackground)
        realBackground.setCornerBorder()
        titleLabel = UILabel(title: "", size: 18.0, color: .label)
        
        closeButton = MHButton(icon: #imageLiteral(resourceName: "ic_close").withRenderingMode(.alwaysTemplate), bgColor: .secondarySystemBackground)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(self.backToPreviousVC), for: .touchUpInside)
        self.view.addSubViews([realBackground, titleLabel, closeButton])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
        realBackground.setHeightConstraint(0.6 * height)
        realBackground.setWidthConstraint(0.8 * width)
        self.view.centerSubView(realBackground)
        closeButton.setConstraintsToView(top: realBackground, tConst: 5, right: realBackground, rConst: -5)
        closeButton.heightAnchor.constraint(equalTo: realBackground.heightAnchor, multiplier: 0.1).isActive = true
        titleLabel.setConstraintsToView(top: closeButton, bottom: closeButton, left: self.view, right: self.view)
        self.view.layoutIfNeeded()
    }
}
