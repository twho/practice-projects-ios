//
//  ToDoListViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import UIKit
import MapKit

class ToDoListViewController: UIViewController, ToDoListViewProtocol {
    // VIPER
    var presenter: ToDoListPresenterProtocol?
    // UI
    private var navbar: UINavigationBar!
    private var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var addButton: MHButton!
    private var tasks = [Task]()
    
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
        navbar = addNavigationBar(title: Constants.Example.viperExample.title,
                                  rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close"), style: .done, target: self, action: #selector(self.backToPreviousVC)))
        self.view.addSubViews([tableView, addButton])
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
        presenter?.viewDidAppear()
    }
    
    func showTasks(_ newTasks: [Task]) {
        let shouldReload = self.tasks != newTasks
        self.tasks = newTasks
        if shouldReload {
            self.tableView.reloadDataWithAnimation()
        }
    }
    
    @objc func addButtonPressed() {
        presenter?.prepareTaskViewController(nil)
    }
    
    func dismissSearchController() {
        self.searchController.dismiss(animated: true, completion: nil)
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
            cell.textLabel?.text = tasks[indexPath.row].content
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            cell.detailTextLabel?.text = formatter.string(from: tasks[indexPath.row].timestamp.unsafelyUnwrapped)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteTask(self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)
            self.tableView.reloadDataWithAnimation()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.prepareTaskViewController(tasks[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
