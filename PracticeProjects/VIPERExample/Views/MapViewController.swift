//
//  MapViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import UIKit
import MapKit

class ToDoListViewController: UIViewController, MapViewProtocol {
    var presenter: MapPresenterProtocol?
    
    private var mapView: MKMapView!
    private var searchbar: UISearchBar!
    private var navbar: UINavigationBar!
    private var resultsView: UITableView!
    private var cancelButton: UIButton!
    
    private var searchTask = DispatchWorkItem {
        
    }
    private var places = [Place]()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        mapView = MKMapView()
        mapView.delegate = self
        searchbar = UISearchBar()
        searchbar.delegate = self
        searchbar.backgroundImage = UIImage(color: .secondarySystemBackground)
        cancelButton = MHButton(text: "Cancel", bgColor: .systemFill)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        setupResultsView()
        self.view.addSubViews([mapView, resultsView, cancelButton, searchbar])
        navbar = self.addNavigationBar(title: "VIPER Map")
    }
    
    private func setupResultsView() {
        resultsView = UITableView()
        resultsView.backgroundColor = .systemBackground
        (resultsView.delegate, resultsView.dataSource) = (self, self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = self.view.frame.width
        let height = self.view.frame.height
        searchbar.topAnchor.constraint(equalTo: self.navbar.bottomAnchor).isActive = true
        searchbar.setConstraintsToView(left: self.view, right: self.view)
        resultsView.topAnchor.constraint(equalTo: searchbar.bottomAnchor).isActive = true
        cancelButton.setConstraintsToView(bottom: self.view, bConst: -0.05 * height,
                                          left: self.view, lConst: 0.3 * width,
                                          right: self.view, rConst: -0.3 * width)
        resultsView.setConstraintsToView(bottom: self.view, left: self.view, right: self.view)
        mapView.setConstraintsToView(top: self.view, bottom: self.view, left: self.view, right: self.view)
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    @objc func cancelButtonPressed() {
        self.searchbar.endEditing(true)
    }
    
    func setResultsViewVisibility(_ visible: Bool) {
        resultsView.isHidden = !visible
        cancelButton.isHidden = !visible
    }
    
    func showSearchResults(_ places: [Place]) {
        self.places = places
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        presenter?.setSearchingState(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        presenter?.setSearchingState(false)
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellReuseIdentifier)
        if !self.places.isEmpty {
            cell.textLabel?.text = places[indexPath.row].name
            cell.detailTextLabel?.text = places[indexPath.row].address
        }
        return cell
    }
}

// MARK: - MKMapViewDelegate
extension ToDoListViewController: MKMapViewDelegate {
    
}
