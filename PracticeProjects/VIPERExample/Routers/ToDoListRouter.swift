//
//  ToDoListRouter.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import UIKit

class ToDoListRouter: NSObject, ToDoListRouterProtocol {
    
    static func createToDoModule() -> UIViewController {
        let view: ToDoListViewProtocol & UIViewController = ToDoListViewController()
        let presenter: ToDoListPresenterProtocol & ToDoListInteractorOutputProtocol = ToDoListPresenter()
        let interactor: ToDoListInteractorInputProtocol = ToDoListInteractor()
        let localDataManager: ToDoListLocalDataManagerInputProtocol = ToDoListLocalDataManager.shared
        let router: ToDoListRouterProtocol = ToDoListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.localDataManager = localDataManager
        return view
    }
    
    func presentAddTaskViewController(from view: ToDoListViewProtocol, _ task: Task?, _ dismissBlock: (() -> ())?) {
        let addTaskViewController = TaskViewController()
        addTaskViewController.dismissBlock = dismissBlock
        
        if let task = task {
            addTaskViewController.task = task
        }
   
        if let sourceView = view as? UIViewController {
            sourceView.present(addTaskViewController, animated: true)
        }
    }
}
