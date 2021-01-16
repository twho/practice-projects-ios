//
//  ToDoListPresenter.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import UIKit

class ToDoListPresenter: ToDoListPresenterProtocol {
    // VIPER
    weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorInputProtocol?
    var router: ToDoListRouterProtocol?
    
    func viewDidAppear() {
        interactor?.retrieveToDoList(nil)
    }
    
    func shouldUpdateSearchResults(_ searchText: String?) {
        interactor?.retrieveToDoList(searchText == "" ? nil : searchText)
    }
    
    func prepareTaskViewController(_ task: Task?) {
        view?.dismissSearchController()
        router?.presentAddTaskViewController(from: view.unsafelyUnwrapped, task) { [weak self] in
            self?.interactor?.retrieveToDoList(nil)
        }
    }
    
    func deleteTask(_ task: Task) {
        interactor?.deleteTask(task)
    }
}

extension ToDoListPresenter: ToDoListInteractorOutputProtocol {
    
    func onError() {
        
    }
    
    func didRetrieveTasks(_ tasks: [Task]) {
        view?.showTasks(tasks)
    }
    
    func didDeleteTask(_ error: Error?) {
        if let error = error {
            // error handling
            print(error)
        }
    }
}
