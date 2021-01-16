//
//  ToDoListProtocols.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import UIKit

protocol ToDoListViewProtocol: class {
    var presenter: ToDoListPresenterProtocol? { get set }
    
    // Presenter -> View
}

protocol ToDoListRouterProtocol: class {
    static func createMapModule() -> UIViewController
    func presentAddTaskViewController(from view: ToDoListViewProtocol)
}

protocol ToDoListPresenterProtocol: class {
    var view: ToDoListViewProtocol? { get set }
    var interactor: ToDoListInteractorInputProtocol? { get set }
    var router: ToDoListRouterProtocol? { get set }
    
    // View -> Presenter
    func viewDidLoad()
    func shouldUpdateSearchResults(_ searchText: String?)
    func addNewTask()
}

protocol ToDoListInteractorOutputProtocol: class {
    // Interactor -> Presenter
    func onError()
}

protocol ToDoListInteractorInputProtocol: class {
    var presenter: ToDoListInteractorOutputProtocol? { get set }
    var localDataManager: ToDoListLocalDataManagerInputProtocol? { get set }
    
    // Presenter -> Interactor
    func retrieveToDoList() -> [Task]
}

protocol ToDoListLocalDataManagerInputProtocol: class {
    // Interactor -> LocalDataManager
    func retrieveToDoList() throws -> [Task]
    func saveTask(_ name: String, _ content: String) throws
}
