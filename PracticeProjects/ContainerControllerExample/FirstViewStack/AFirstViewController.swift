//
//  AFirstViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/10/21.
//

import UIKit

class AFirstViewController: SimpleDisplayViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI(backgroundColor: .blue, nextViewController: BFirstViewController.self)
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
