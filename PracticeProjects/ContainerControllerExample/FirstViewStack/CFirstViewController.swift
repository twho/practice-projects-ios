//
//  CFirstViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/10/21.
//

import UIKit

class CFirstViewController: SimpleDisplayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI(backgroundColor: .cyan, nextViewController: AFirstViewController.self)
    }
}
