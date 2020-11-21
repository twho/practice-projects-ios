//
//  ViewController.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/18/20.
//

import UIKit

class ListViewController: UIViewController {
    // UI widgets
    private var tableView: UITableView!
    private var navbar: UINavigationBar!
    // Private properties
    private lazy var jsonHelper: JSONHelper = {
        return JSONHelper()
    }()
    private var restaurantData = [Restaurant]()
    
    // MARK: - Constants
    private let tableCellReuseIdentifier = "listTableViewCell"
    private let JSONFile = (name: "RestaurantSamples", directory: "restaurants")

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = self.addNavigationBar(title: "Restaurant List")
        restaurantData = jsonHelper.readLocalJSONFile(JSONFile.name, Restaurant.self, JSONFile.directory)
        setupTableView()
    }
    
    override func loadView() {
        super.loadView()
        self.navbar = self.addNavigationBar(title: "Restaurant List")
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
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
    }
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier) as UITableViewCell?
        if let listCell = cell as? ListTableViewCell {
            listCell.loadDataToView(restaurantData[indexPath.item])
        }
        return cell!
    }
}
