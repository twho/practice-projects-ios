//
//  CFirstViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/10/21.
//

import UIKit

class CViewController: SimpleDisplayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI(backgroundColor: .cyan, nextViewController: AViewController.self)
    }
}
