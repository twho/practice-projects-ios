//
//  MenuViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/22/20.
//

import UIKit

class MenuViewController: UIViewController {
    // UI
    private var navbar: UINavigationBar!
    private(set) var stackView: UIStackView!
    // Data
    private let examples: [Constants.Example] = [.imageLoader, .jsonDecoding, .restAPI, .viperExample,
                                                 .hitTestResponder, .GCDExample, .containerController]
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        navbar = self.addNavigationBar(title: Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "")
        stackView = UIStackView(axis: .vertical, distribution: .fillEqually, spacing: 0.025 * self.view.frame.height)
        self.view.addSubViews([stackView])
    }
    // viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = self.view.frame.width
        let height = self.view.frame.height
        stackView.topAnchor.constraint(equalTo: navbar.bottomAnchor, constant: 0.025 * height).isActive = true
        stackView.setConstraintsToView(left: self.view, lConst: 0.1 * width, right: self.view, rConst: -0.1 * width)
        stackView.setHeightConstraint(CGFloat(self.examples.count + 1) * 80)
        self.view.layoutIfNeeded()
    }
    // viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if stackView.subviews.count != self.examples.count + 1 {
            stackView.removeAllSubviews()
            let instructions = UILabel(title: "Select one of the following examples", size: 18.0, color: .label, numOfLines: 2)
            stackView.addArrangedSubview(instructions)
            // Setup buttons
            for example in examples {
                let button = MHButton(example: example)
                button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
                stackView.addArrangedSubview(button)
            }
        }
    }
    /**
     Handle button click event. Present the example view controller user clicked.
     
     - Parameter sender: The button clicked by the user.
     */
    @objc func buttonClicked(_ sender: UIButton) {
        if let exampleButton = sender as? MHButton {
            let vcToPresent = exampleButton.example.viewController
            self.presentInFullscreen(vcToPresent)
        }
    }
}
