//
//  UserCardViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/28/20.
//

import UIKit

// MVVM
class UserCardViewController: DialogViewController {
    private(set) var stackView: UIStackView!
    let viewModel: UserCardViewModel
    var isAnimating = false
    // Override init
    init(viewModel: UserCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    // Required init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        stackView = UIStackView(arrangedSubviews: nil, axis: .vertical, distribution: .fillEqually, spacing: 5.0)
        self.view.addSubViews([stackView])
        setupViewModel()
    }
    /**
     Set up view model.
     */
    private func setupViewModel() {
        viewModel.didUpdatePersonData = { [weak self] (person) in
            guard let self = self else { return }
            if let people = person {
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
                self.titleLabel.text = people.personName
            }
        }
    }
    // viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        let width = self.view.frame.size.width
        stackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor).isActive = true
        stackView.setConstraintsToView(bottom: realBackground, bConst: -10,
                                       left: realBackground, lConst: 0.05 * width, right: realBackground, rConst: -0.05 * width)
        super.viewDidLayoutSubviews()
    }
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.ready()
    }
    /**
     Reload data into the stack view.
     
     - Parameter data: The people data object.
     */
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
