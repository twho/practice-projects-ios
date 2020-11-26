//
//  ViewController.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/18/20.
//

import UIKit

class ListViewController: UIViewController {
    // UI widgets
    private(set) var tableView: UITableView!
    private(set) var navbar: UINavigationBar!
    // Data
    var restaurantData = [Restaurant]()
    // Constants
    private let tableCellReuseIdentifier = String(describing: self) + "TableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
        setupTableView()
    }
    
    func loadInitialData() {
        restaurantData = JSONHelper.shared.readLocalJSONFile(Constants.JSONFileName.restaurants.name, Restaurant.self, Constants.JSONFileName.restaurants.directory)
    }
    
    override func loadView() {
        super.loadView()
        self.navbar = self.addNavigationBar(title: Constants.Example.jsonParser.title,
                                            rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close").colored(.white), style: .done, target: self, action: #selector(self.backToPreviousVC)))
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: tableCellReuseIdentifier)
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
        self.tableView.reloadData()
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ListDetailViewController()
        detailVC.restaurant = restaurantData[indexPath.row]
        self.present(detailVC, animated: true, completion: nil)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier) as UITableViewCell?
        if let listCell = cell as? ListTableViewCell {
            listCell.loadDataToView(restaurantData[indexPath.row])
        }
        return cell!
    }
}
