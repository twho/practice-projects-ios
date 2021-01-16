//
//  ToDoListViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import UIKit
import MapKit

class ToDoListViewController: UIViewController, ToDoListViewProtocol {
    var presenter: ToDoListPresenterProtocol?
    
    private var navbar: UINavigationBar!
    private var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var addButton: MHButton!
    
    private var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        tableView = UITableView()
        (tableView.delegate, tableView.dataSource) = (self, self)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        addButton = MHButton(text: "New Task", bgColor: .systemFill)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        navbar = self.addNavigationBar(title: "VIPER")
        self.view.addSubViews([tableView, addButton])
    }
    
    private func setupResultsView() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = self.view.frame.width
        let height = self.view.frame.height
        tableView.topAnchor.constraint(equalTo: self.navbar.bottomAnchor).isActive = true
        tableView.setConstraintsToView(bottom: self.view, left: self.view, right: self.view)
        addButton.setConstraintsToView(bottom: self.view, bConst: -0.05 * height,
                                       left: self.view, lConst: 0.2 * width,
                                       right: self.view, rConst: -0.2 * width)
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func addButtonPressed() {
        presenter?.addNewTask()
    }
    
    func showSearchResults(_ tasks: [Task]) {
        self.tasks = tasks
    }
}

extension ToDoListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.shouldUpdateSearchResults(searchController.searchBar.text)
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellReuseIdentifier)
        if !self.tasks.isEmpty {
            cell.textLabel?.text = tasks[indexPath.row].name
            cell.detailTextLabel?.text = tasks[indexPath.row].content
        }
        return cell
    }
}
