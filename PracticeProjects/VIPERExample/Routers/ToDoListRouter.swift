//
//  ToDoListRouter.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import UIKit

class ToDoListRouter: NSObject, ToDoListRouterProtocol {
    
    static func createMapModule() -> UIViewController {
        let view: ToDoListViewProtocol & UIViewController = ToDoListViewController()
        let presenter: ToDoListPresenterProtocol & ToDoListInteractorOutputProtocol = ToDoListPresenter()
        let interactor: ToDoListInteractorInputProtocol = ToDoListInteractor()
        let localDataManager: ToDoListLocalDataManagerInputProtocol = ToDoListLocalDataManager()
        let router: ToDoListRouterProtocol = ToDoListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.localDataManager = localDataManager
        return view
    }
    
    func presentAddTaskViewController(from view: ToDoListViewProtocol) {
        let addTaskViewController = AddTaskViewController()
   
        if let sourceView = view as? UIViewController {
            sourceView.present(addTaskViewController, animated: true)
        }
    }
}
