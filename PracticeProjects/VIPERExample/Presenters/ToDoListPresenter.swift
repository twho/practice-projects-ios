//
//  ToDoListPresenter.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import UIKit

class ToDoListPresenter: ToDoListPresenterProtocol {

    weak var view: ToDoListViewProtocol?
    
    var interactor: ToDoListInteractorInputProtocol?
    
    var router: ToDoListRouterProtocol?
    
    func viewDidLoad() {
        
    }
    
    func shouldUpdateSearchResults(_ searchText: String?) {
        
    }
    
    func addNewTask() {
        router?.presentAddTaskViewController(from: view.unsafelyUnwrapped)
    }
}

extension ToDoListPresenter: ToDoListInteractorOutputProtocol {
    
    func onError() {
        
    }
}
