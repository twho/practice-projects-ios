//
//  ListDetailViewController.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/21/20.
//

import UIKit

// TODO: Load cuisine in table view here.
class ListDetailViewController: UIViewController {
    // UI
    var tableView: UITableView!
    private var navbar: UINavigationBar!
    var restaurant: Restaurant? {
        didSet {
            title = restaurant?.name
        }
    }
    var mealData = [Meal]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubViews([tableView])
    }
    
    override func loadView() {
        super.loadView()
        navbar = self.addNavigationBar(title: title ?? "Detail",
                                       leftBarItem: nil,
                                       rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close").colored(.white), style: .done, target: self, action: #selector(self.backToPreviousVC)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        tableView.setConstraintsToView(bottom: self.view, left: self.view, right: self.view)
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadInitialData()
    }
    // Override for testing
    func loadInitialData() {
        mealData = JSONHelper.shared.readLocalJSONFile(Constants.JSON.meals(restaurant?.name).name, Meal.self, Constants.JSON.meals(restaurant?.name).directory)
    }
}

extension ListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if let cell = reuseCell {
            let meal = mealData[indexPath.row]
            cell.textLabel?.text = meal.name
        }
        return reuseCell!
    }
}
