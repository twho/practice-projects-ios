//
//  AddTaskViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/15/21.
//

import UIKit

// MVC architecture
class TaskViewController: DialogViewController {
    // UI
    private var taskContentTextView: UITextView!
    private var addButton: MHButton!
    private let localDataMgr = ToDoListLocalDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = "Add a New Task"
        taskContentTextView = UITextView()
        taskContentTextView.setCornerBorder(cornerRadius: 5, borderWidth: 0)
        addButton = MHButton(text: "Add", bgColor: .systemFill)
        addButton.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        self.view.addSubViews([taskContentTextView, addButton])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = self.realBackground.frame.width
        let height = self.realBackground.frame.height
        taskContentTextView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 0.05 * height).isActive = true
        taskContentTextView.setConstraintsToView(left: realBackground, lConst: 0.05 * width,
                                                 right: realBackground, rConst: -0.05 * width)
        taskContentTextView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -0.05 * height).isActive = true
        addButton.setConstraintsToView(bottom: self.realBackground, bConst: -0.05 * height,
                                       left: self.realBackground, lConst: 0.2 * width,
                                       right: self.realBackground, rConst: -0.2 * width)
        super.viewDidLayoutSubviews()
    }
    
    @objc func addNewTask() {
        if let text = taskContentTextView.text, text != "" {
            do {
                try localDataMgr.saveTask(text)
                self.dismiss(animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
    }
}
