//
//  UserCardViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/28/20.
//

import UIKit

class UserCardViewController: DialogViewController {
    private var stackView: UIStackView!
    var people: People?
    var isAnimating = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        stackView = UIStackView(arrangedSubviews: nil, axis: .vertical, distribution: .fillEqually, spacing: 5.0)
        self.view.addSubViews([stackView])
    }
    
    override func viewDidLayoutSubviews() {
        let width = self.view.frame.size.width
        stackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor).isActive = true
        stackView.setConstraintsToView(bottom: realBackground, bConst: -10, left: realBackground, lConst: 0.05 * width, right: realBackground, rConst: -0.05 * width)
        super.viewDidLayoutSubviews()
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
            titleLabel.text = people.personName
        }
    }
    
    private func reloadStackData(_ data: People) {
        stackView.removeAllSubviews()
        stackView.addArrangedSubview(InfoPairView(parameter: "Username", value: data.username))
        stackView.addArrangedSubview(InfoPairView(parameter: "Email", value: data.email))
        stackView.addArrangedSubview(InfoPairView(parameter: "Phone", value: data.phone))
        stackView.addArrangedSubview(InfoPairView(parameter: "Company", value: data.company?.name ?? "N/A"))
        stackView.addArrangedSubview(InfoPairView(parameter: "Website", value: data.website))
        self.view.layoutIfNeeded()
    }
}
