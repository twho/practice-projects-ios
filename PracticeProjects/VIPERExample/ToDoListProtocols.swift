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
    func showTasks(_ tasks: [Task])
    func dismissSearchController()
}

protocol ToDoListRouterProtocol: class {
    static func createToDoModule() -> UIViewController
    func presentAddTaskViewController(from view: ToDoListViewProtocol, _ task: Task?, _ dismissBlock: (() -> ())?)
}

protocol ToDoListPresenterProtocol: class {
    var view: ToDoListViewProtocol? { get set }
    var interactor: ToDoListInteractorInputProtocol? { get set }
    var router: ToDoListRouterProtocol? { get set }
    
    // View -> Presenter
    func viewDidAppear()
    func shouldUpdateSearchResults(_ searchText: String?)
    func prepareTaskViewController(_ task: Task?)
    func deleteTask(_ task: Task)
}

protocol ToDoListInteractorOutputProtocol: class {
    // Interactor -> Presenter
    func didRetrieveTasks(_ tasks: [Task])
    func didDeleteTask(_ error: Error?)
    func onError()
}

protocol ToDoListInteractorInputProtocol: class {
    var presenter: ToDoListInteractorOutputProtocol? { get set }
    var localDataManager: ToDoListLocalDataManagerInputProtocol? { get set }
    
    // Presenter -> Interactor
    func retrieveToDoList(_ keyword: String?)
    func deleteTask(_ task: Task)
}

protocol ToDoListLocalDataManagerInputProtocol: class {
    // Interactor -> LocalDataManager
    func retrieveToDoList(_ keyword: String?) throws -> [Task]
    func deleteTaskInStorage(_ task: Task) throws 
}
