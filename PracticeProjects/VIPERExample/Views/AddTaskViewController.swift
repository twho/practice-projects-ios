//
//  AddTaskViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/15/21.
//

import UIKit

// Based on MVC architecture
class AddTaskViewController: DialogViewController {
    
    override func loadView() {
        super.loadView()
        self.titleLabel.text = "Add a New Task"
    }
}
