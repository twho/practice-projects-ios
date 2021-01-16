//
//  TaskViewController.swift
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
    var task: Task?
    var dismissBlock: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = "Add a New Task"
        taskContentTextView = UITextView()
        taskContentTextView.setCornerBorder(cornerRadius: 5, borderWidth: 0)
        taskContentTextView.font = .systemFont(ofSize: 16.0)
        taskContentTextView.becomeFirstResponder()
        addButton = MHButton(text: "Add", bgColor: .systemFill)
        addButton.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        if let task = self.task {
            addButton.setTitle("Modify")
            titleLabel.text = "Modify a Task"
            taskContentTextView.text = task.content
        }
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        addButton.setTitle("Add")
        titleLabel.text = "Add a New Task"
        task = nil
    }
    
    @objc func addNewTask() {
        do {
            if let text = taskContentTextView.text, text != "" {
                if let task = task {
                    task.timestamp = Date()
                    task.content = text
                    try localDataMgr.updateTask(task)
                } else {
                    try localDataMgr.saveTask(text)
                }
            }
            self.dismiss(animated: true, completion: dismissBlock)
        } catch {
            print(error)
        }
    }
}
