//
//  MapViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapViewProtocol {
    var presenter: MapPresenterProtocol?
    
    private var mapView: MKMapView!
    private var searchbar: UISearchBar!
    private var navbar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        mapView = MKMapView()
        mapView.delegate = self
        searchbar = UISearchBar()
        searchbar.backgroundImage = UIImage(color: .secondarySystemBackground)
        self.view.addSubViews([mapView, searchbar])
        navbar = self.addNavigationBar(title: "VIPER Map")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = self.view.frame.width
        let height = self.view.frame.height
        searchbar.topAnchor.constraint(equalTo: self.navbar.bottomAnchor).isActive = true
        searchbar.setConstraintsToView(left: self.view, right: self.view)
        mapView.setConstraintsToView(top: self.view, bottom: self.view, left: self.view, right: self.view)
        self.view.layoutIfNeeded()
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
}
