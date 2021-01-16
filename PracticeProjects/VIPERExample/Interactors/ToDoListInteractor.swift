//
//  ToDoListInteractor.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

class ToDoListInteractor: ToDoListInteractorInputProtocol {
    weak var presenter: ToDoListInteractorOutputProtocol?
    var localDataManager: ToDoListLocalDataManagerInputProtocol?
    
    func retrieveToDoList() -> [Task] {
        return []
    }
}
