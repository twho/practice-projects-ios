//
//  ListDetailViewController.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/21/20.
//

import UIKit

class ListDetailViewController: UIViewController {

    private var navbar: UINavigationBar!
    var restaurant: Restaurant? {
        didSet {
            title = restaurant?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func loadView() {
        super.loadView()
        navbar = self.addNavigationBar(title: title ?? "Detail",
                                       leftBarBtnItem: nil,
                                       rightBarBtnItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close").colored(.white), style: .done, target: self, action: #selector(self.backToPreviousVC)))
    }
}
