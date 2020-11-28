//
//  ContactsViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/27/20.
//

import UIKit

// https://jsonplaceholder.typicode.com/
class ContactsViewController: UIViewController {
    // UI widgets
    var searchBar: UISearchBar!
    var tableView: UITableView!
    private(set) var navbar: UINavigationBar!
    // Properties for state driven collectionView
    private(set) var activityIndicator: UIActivityIndicatorView!
    private(set) var loadingView: UIView!
    private(set) var emptyView: UIView!
    private(set) var errorView: UIView!
    private(set) var errorLabel: UILabel!
    // Data
    var state = CollectionState.loading {
        didSet {
            getGCDHelperInContext().runOnMainThread { [weak self] in
                guard let self = self else { return }
                self.setFooterView()
                // Reload table with animations
                let range = NSMakeRange(0, self.tableView.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)
                self.tableView.reloadSections(sections as IndexSet, with: .automatic)
            }
        }
    }
    private let rowHeight: CGFloat = 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        navbar = addNavigationBar(title: Constants.Example.restAPI.title,
                                  rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close").colored(.white), style: .done, target: self, action: #selector(self.backToPreviousVC)))
        searchBar = UISearchBar()
        setupTableView()
    }
    /**
     Set up tableView.
     */
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        (tableView.delegate, tableView.dataSource) = (self, self)
        self.view.addSubViews([tableView])
    }
    /**
     Setup for state driven collectionView. (This part is not must-have for the example)
     */
    private func setupStateViews() {
        // Loading view
        activityIndicator = UIActivityIndicatorView()
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.rowHeight))
        loadingView.addSubViews([activityIndicator])
        loadingView.centerSubView(activityIndicator)
        // Empty view
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.rowHeight))
        let noResultLabel = UILabel(title: "No results! Try searching for something else.", size: 17.0, bold: false, color: .black)
        emptyView.addSubViews([noResultLabel])
        noResultLabel.setConstraintsToView(left: emptyView, right: emptyView)
        emptyView.centerSubView(noResultLabel)
        // Error view
        errorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.rowHeight))
        errorLabel = UILabel(title: "There is an error.", size: 17.0, bold: false, color: .black)
        errorView.addSubViews([errorLabel])
        errorLabel.setConstraintsToView(left: errorView, right: errorView)
        errorView.centerSubView(errorLabel)
        [errorLabel, noResultLabel].forEach({
            $0!.numberOfLines = 2
        })
        self.setFooterView()
    }
    
    private func setFooterView() {
        switch state {
        case .error(let error):
            errorLabel.text = error.localizedDescription
            tableView.tableFooterView = errorView
        case .loading:
            activityIndicator.startAnimating()
            tableView.tableFooterView = loadingView
        case .empty:
            tableView.tableFooterView = emptyView
        case .populated:
            tableView.tableFooterView = nil
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        searchBar.setConstraintsToView(left: self.view, right: self.view)
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.setConstraintsToView(left: self.view, right: self.view)
        self.view.layoutIfNeeded()
    }
    // viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    // Override for testing
    /**
     Load initial data to display.
     */
    func loadInitialData() {
        let data = JSONHelper.shared.readLocalJSONFile(Constants.JSON.restaurants.name, Restaurant.self, Constants.JSON.restaurants.directory)
        state = .populated(data)
    }
    /**
     Method to provide GCD helper based on the current context, used for test override.
     
     - Returns: An GCD helper used in current context.
     */
    func getGCDHelperInContext() -> GCDHelper {
        return GCDHelper.shared
    }
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        
        return cell!
    }
}
