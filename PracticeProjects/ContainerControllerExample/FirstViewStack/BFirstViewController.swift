//
//  BFirstViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/10/21.
//

import UIKit

class BFirstViewController: SimpleDisplayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI(backgroundColor: .brown, nextViewController: CFirstViewController.self)
    }

    override func didReceiveMemoryWarning() {
        // Check if the view is currently visible
        if self.isViewLoaded, self.view.window == nil {
            self.view = nil
        }
        // Also Nullify some data that can be created easily
        super.didReceiveMemoryWarning()
    }
}
