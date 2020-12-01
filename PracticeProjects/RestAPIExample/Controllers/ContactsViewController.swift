//
//  ContactsViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/27/20.
//

import UIKit

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
                if self.isViewVisible {
                    let range = NSMakeRange(0, self.tableView.numberOfSections)
                    let sections = NSIndexSet(indexesIn: range)
                    self.tableView.reloadSections(sections as IndexSet, with: .automatic)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    /**
     The poeple data is used to keep track of the original data loaded from JSON. It has
     difference purpose from state.elements. It should be in sync with JSON.
     */
    var peopleData: [People]?
    private var searchTask: DispatchWorkItem?
    private let rowHeight: CGFloat = 60.0
    /**
     The URL we are using to fetch data for this demo. The original JSON file is also included
     at the path - RestAPIExample/PeopleSample.json in case the web service is not working.
     */
    private let urlString = "https://jsonplaceholder.typicode.com/users"
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    // loadView
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .systemBackground
        navbar = addNavigationBar(title: Constants.Example.restAPI.title,
                                  rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close"), style: .done, target: self, action: #selector(self.backToPreviousVC)))
        setupTableView()
        setupStateViews()
        searchBar = UISearchBar()
        searchBar.delegate = self
        self.view.addSubViews([searchBar])
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
        let noResultLabel = UILabel(title: "No results! Try searching for something else.", size: 17.0, bold: false, color: .label)
        emptyView.addSubViews([noResultLabel])
        noResultLabel.setConstraintsToView(left: emptyView, right: emptyView)
        emptyView.centerSubView(noResultLabel)
        // Error view
        errorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.rowHeight))
        errorLabel = UILabel(title: "There is an error.", size: 17.0, bold: false, color: .label)
        errorView.addSubViews([errorLabel])
        errorLabel.setConstraintsToView(left: errorView, right: errorView)
        errorView.centerSubView(errorLabel)
        [errorLabel, noResultLabel].forEach({
            $0!.numberOfLines = 2
        })
        self.setFooterView()
    }
    
    func updateTableViewResults(_ newData: [People]?, error: Error?) {
        if let error = error {
            state = .error(error)
            return
        }
        guard let newData = newData, !newData.isEmpty else {
            state = .empty
            return
        }
        state = .populated(newData)
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
    // viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        searchBar.setConstraintsToView(left: self.view, right: self.view)
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.setConstraintsToView(bottom: self.view, left: self.view, right: self.view)
        self.view.layoutIfNeeded()
    }
    // viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadInitialData()
    }
    // Override for testing
    /**
     Load initial data to display.
     */
    func loadInitialData() {
        RestAPIHelper.shared.fetch(urlString, People.self, nil, { [weak self] result in
            guard let self = self else { return }
            do {
                self.peopleData = try result.get()
                self.getGCDHelperInContext().runOnMainThread {
                    self.updateTableViewResults(self.peopleData, error: nil)
                }
            } catch {
                self.state = .error(error)
                print(self.logtag + error.localizedDescription)
            }
        })
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
        let userCardVC = UserCardViewController()
        if let data = self.peopleData {
            userCardVC.people = data[indexPath.row]
            self.present(userCardVC, animated: true, completion: nil)
        } else {
            // TODO: Error handling
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellReuseIdentifier)
        if let people = state.elements as? [People] {
            cell.textLabel?.text = people[indexPath.row].name
            cell.detailTextLabel?.text = people[indexPath.row].phone
        }
        return cell
    }
}

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let startSearch = self.searchTask {
            startSearch.cancel()
        }
        self.searchTask = DispatchWorkItem { [weak self] in
            guard let self = self, let searchTask = self.searchTask, !searchTask.isCancelled else { return }
            if searchText.isEmpty {
                self.updateTableViewResults(self.peopleData, error: nil)
            } else if let data = self.peopleData, !data.isEmpty {
                self.updateTableViewResults(data.filter { $0.name.contains(searchText) }, error: nil)
            }
        }
        getGCDHelperInContext().runOnMainThreadAfter(delay: 0.5) {
            self.searchTask?.perform()
        }
    }
}
