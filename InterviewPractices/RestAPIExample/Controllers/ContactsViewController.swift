//
//  ContactsViewController.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/27/20.
//

import UIKit

// https://jsonplaceholder.typicode.com/
class ContactsViewController: UIViewController {
    // UI widgets
    var searchView: UISearchBar!
    var tableView: UITableView!
    private(set) var navbar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        navbar = addNavigationBar(title: Constants.Example.imageLoader.title,
                                  rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close").colored(.white), style: .done, target: self, action: #selector(self.backToPreviousVC)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}
