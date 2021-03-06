//
//  ViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/18/20.
//

import UIKit

class ListViewController: UIViewController {
    // UI widgets
    var tableView: UITableView!
    private(set) var navbar: UINavigationBar!
    // Data
    var isAnimating = false
    var restaurantData: [Restaurant] = [] {
        didSet {
            if self.isViewVisible, !self.isAnimating {
                self.runInAnimation { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                    self.isAnimating = true
                } completion: { _ in
                    self.isAnimating = false
                }
            } else {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func loadView() {
        super.loadView()
        self.navbar = self.addNavigationBar(title: Constants.Example.jsonDecoding.title,
                                            rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close"), style: .done, target: self, action: #selector(self.backToPreviousVC)))
    }
    /**
     Set up tableView.
     */
    private func setupTableView() {
        tableView = UITableView()
        registerTableViewCell()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubViews([tableView])
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        self.tableView.setConstraintsToView(bottom: self.view, left: self.view, right: self.view)
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadInitialData()
    }
    // Override for testing
    func loadInitialData() {
        JSONHelper.shared.readLocalJSONFile(Constants.JSON.restaurants.name, Restaurant.self, Constants.JSON.restaurants.directory) { [weak self] result in
            guard let self = self else { return }
            do {
                self.restaurantData = try result.get()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func registerTableViewCell() {
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func getListDetailViewController() -> ListDetailViewController {
        return ListDetailViewController()
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = getListDetailViewController()
        detailVC.restaurant = restaurantData[indexPath.row]
        let cell = self.tableView(self.tableView, cellForRowAt: indexPath)
        if let listCell = cell as? ListTableViewCell {
            detailVC.imageView.image = listCell.restaurantImageView.image?.cropToWideRatio()
        }
        // Present the detail view controller
        self.presentInFullscreen(detailVC)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if let listCell = cell as? ListTableViewCell {
            listCell.loadDataToView(restaurantData[indexPath.row])
        }
        return cell!
    }
}
