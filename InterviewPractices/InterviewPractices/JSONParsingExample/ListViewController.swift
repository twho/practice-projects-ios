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
        setupTableView()
        
        restaurantData = jsonHelper.readLocalJSONFile(JSONFile.name, Restaurant.self, JSONFile.directory)
        for res in restaurantData {
            
        }
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: tableCellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubViews([tableView])
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.setConstraintsToView(top: self.view, bottom: self.view, left: self.view, right: self.view)
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Use https://imgbb.com/ to create image urls
//        let url = URL(string: "https://i.ibb.co/F0gNC4J/pexels-valeria-boltneva-1251208.jpg")
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//                self.imageView.image = UIImage(data: data!)
//            }
//        }
//        imageView.backgroundColor = .blue
    }
}

extension ListViewController: UITableViewDelegate {
    
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier) as UITableViewCell?
        if let listCell = cell as? ListTableViewCell {
            
        }
        return cell!
    }
}
