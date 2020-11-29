//
//  UserCardViewController.swift
//  PracticeProjects
//
//  Created by Amy Shih on 11/28/20.
//

import UIKit

class UserCardViewController: UIViewController {
    // UI
    private var realBackground: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        realBackground = UIView(color: .systemBackground)
    }
}
