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
    var imageView = UIImageView()
    private(set) var headerTitle: UILabel!
    private(set) var navbar: UINavigationBar!
    // Data
    var restaurant: Restaurant?
    private(set) var mealMap = [String : [Meal]]()
    private(set) var keyArray = [String]()
    var mealData = [Meal]() {
        didSet {
            for meal in mealData {
                if mealMap[meal.category] == nil {
                    mealMap[meal.category] = []
                }
                mealMap[meal.category]!.append(meal)
            }
            keyArray = Array(mealMap.keys)
            tableView.reloadData()
        }
    }
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    /**
     Set up table view.
     */
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubViews([tableView])
    }
    // loadView
    override func loadView() {
        super.loadView()
        navbar = self.addNavigationBar(title: "Menu",
                                       leftBarItem: nil,
                                       rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close").colored(.white), style: .done, target: self, action: #selector(self.backToPreviousVC)))
        self.view.backgroundColor = .white
        imageView.addBlurryEffect()
        headerTitle = UILabel(title: "", size: 18.0, color: .black)
        self.view.addSubViews([imageView, headerTitle])
    }
    // viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        imageView.setConstraintsToView(left: self.view, right: self.view)
        imageView.setHeightByAspectRatio(imageView.image?.aspectRatio ?? 1.0)
        headerTitle.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        headerTitle.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        tableView.setConstraintsToView(bottom: self.view, left: self.view, right: self.view)
        self.view.layoutIfNeeded()
    }
    // viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadInitialData()
        headerTitle.text = restaurant?.name
    }
    // Override for testing
    func loadInitialData() {
        mealData = JSONHelper.shared.readLocalJSONFile(Constants.JSON.meals(restaurant?.name).name, Meal.self, Constants.JSON.meals(restaurant?.name).directory)
    }
    
    func getImageLoaderInContext() -> ImageLoader {
        return ImageLoader.shared.getImageLoaderInContext()
    }
}

extension ListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keyArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keyArray[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.08
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealMap[keyArray[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellReuseIdentifier)
        let type = keyArray[indexPath.section]
        if let meals = mealMap[type] {
            let meal = meals[indexPath.row]
            cell.textLabel?.text = meal.name
            cell.detailTextLabel?.text = "$\(meal.price)"
        }
        return cell
    }
}
