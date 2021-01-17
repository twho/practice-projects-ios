//
//  ContactsViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/27/20.
//

import UIKit

// MVVM
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
    private let viewModel: ContactsViewModel
    private let rowHeight: CGFloat = 60.0
    // Override init
    init(viewModel: ContactsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    // Required method
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupViewModel()
    }
    /**
     Set up view model.
     */
    private func setupViewModel() {
        viewModel.isRefreshing = { [weak self] loading in
            guard let self = self else { return }
            self.state = .loading
        }
        viewModel.didUpdatePeopleData = { [weak self] peopleData in
            guard let self = self else { return }
            self.state = peopleData.isEmpty ? .empty : .populated(peopleData)
        }
        viewModel.didFailToUpdatePeopleData = { [weak self] error in
            guard let self = self else { return }
            self.state = .error(error)
        }
        viewModel.readyToPresent = { [weak self] vc in
            guard let self = self else { return }
            self.present(vc, animated: true, completion: nil)
        }
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
        let noResultLabel = UILabel(title: "No results have been found! Check if the data resource is valid.",
                                    size: 17.0, bold: false, color: .label, numOfLines: 2)
        emptyView.addSubViews([noResultLabel])
        noResultLabel.setConstraintsToView(left: emptyView, right: emptyView)
        emptyView.centerSubView(noResultLabel)
        // Error view
        errorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.rowHeight))
        errorLabel = UILabel(title: "There is an error.", size: 17.0, bold: false, color: .label)
        errorView.addSubViews([errorLabel])
        errorLabel.setConstraintsToView(left: errorView, right: errorView)
        errorView.centerSubView(errorLabel)
        [errorLabel, noResultLabel].forEach {
            $0!.numberOfLines = 2
        }
        self.setFooterView()
    }
    /**
     Set the footer view to display current state.
     */
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
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.ready()
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
        viewModel.didSelectRow(indexPath)
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
            cell.textLabel?.text = people[indexPath.row].personName
            cell.detailTextLabel?.text = people[indexPath.row].phone
        }
        return cell
    }
}

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.didChangeQuery(searchText)
    }
}
