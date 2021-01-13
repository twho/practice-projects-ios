//
//  SimpleDisplayViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/10/21.
//

import UIKit

class SimpleDisplayViewController: UIViewController {
    var label: UILabel!
    var button: UIButton!
    var nextViewControllerType: AnyClass?

    override func viewDidLoad() {
        super.viewDidLoad()
        label = UILabel(title: "", size: 20.0, color: .label, numOfLines: 3)
        button = UIButton(color: .systemFill)
        button.setTitle("Push to next view controller")
        button.addTarget(self, action: #selector(self.pushToNextViewController), for: .touchUpInside)
        self.view.addSubViews([label, button])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let horizontalMargin = self.view.frame.width * 0.1
        let verticalMargin = self.view.frame.height * 0.1
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.setConstraintsToView(left: self.view, lConst: horizontalMargin, right: self.view, rConst: -horizontalMargin)
        label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 0.2 * verticalMargin).isActive = true
        label.setConstraintsToView(left: self.view, lConst: horizontalMargin, right: self.view, rConst: -horizontalMargin)
        self.view.layoutIfNeeded()
    }
    
    func setupUI(backgroundColor: UIColor, nextViewController: AnyClass) {
        label.text = String(describing: self)
        self.view.backgroundColor = backgroundColor
        self.nextViewControllerType = nextViewController
    }
    
    @objc func pushToNextViewController() {
        if let next = self.nextViewControllerType,
           let reuseNavController = self.navigationController as? ReuseNavigationController {
            reuseNavController.pushReusableViewController(to: next, animated: true)
        }
    }
}
