//
//  UserCardViewController.swift
//  PracticeProjects
//
//  Created by Amy Shih on 11/28/20.
//

import UIKit

class UserCardViewController: UIViewController {
    // UI
    private var realBackground: UIView!
    private var stackView: UIStackView!
    private var closeButton: UIButton!
    private var titleLabel: UILabel!
    // Data
    var people: People?
    var isAnimating = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    override func loadView() {
        super.loadView()
        realBackground = UIView(color: .secondarySystemBackground)
        realBackground.setCornerBorder()
        titleLabel = UILabel(title: "", size: 18.0, color: .label)
        closeButton = MHButton(icon: #imageLiteral(resourceName: "ic_close").withRenderingMode(.alwaysTemplate), bgColor: .secondarySystemBackground)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(self.backToPreviousVC), for: .touchUpInside)
        stackView = UIStackView(arrangedSubviews: nil, axis: .vertical, distribution: .fillEqually, spacing: 5.0)
        self.view.addSubViews([realBackground, titleLabel, closeButton, stackView])
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
        closeButton.setSquarUseHeightReference()
        stackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor).isActive = true
        stackView.setConstraintsToView(bottom: realBackground, bConst: -10, left: realBackground, lConst: 0.05 * width, right: realBackground, rConst: -0.05 * width)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let people = self.people {
            if self.isViewVisible, !self.isAnimating {
                self.runInAnimation { [weak self] in
                    guard let self = self else { return }
                    self.reloadStackData(people)
                    self.isAnimating = true
                } completion: { _ in
                    self.isAnimating = false
                }
            } else {
                self.reloadStackData(people)
            }
            titleLabel.text = people.name
        }
    }
    
    private func reloadStackData(_ data: People) {
        stackView.removeAllSubviews()
        stackView.addArrangedSubview(InfoPairView(parameter: "Username", value: data.username))
        stackView.addArrangedSubview(InfoPairView(parameter: "Email", value: data.email))
        stackView.addArrangedSubview(InfoPairView(parameter: "Phone", value: data.phone))
        stackView.addArrangedSubview(InfoPairView(parameter: "Company", value: data.company.name))
        stackView.addArrangedSubview(InfoPairView(parameter: "Website", value: data.website))
    }
}
