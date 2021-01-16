//
//  ToDoListInteractor.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

class ToDoListInteractor: ToDoListInteractorInputProtocol {
    // VIPER
    weak var presenter: ToDoListInteractorOutputProtocol?
    var localDataManager: ToDoListLocalDataManagerInputProtocol?
    var previousQuery: String?
    
    func retrieveToDoList(_ keyword: String?) {
        var result = [Task]()
        do {
            if let taskList = try localDataManager?.retrieveToDoList(keyword == nil ? previousQuery : keyword) {
                result = taskList
            }
        } catch {
            presenter?.didRetrieveTasks(result)
        }
        presenter?.didRetrieveTasks(result)
        previousQuery = keyword
    }
    
    func deleteTask(_ task: Task) {
        do {
            try localDataManager?.deleteTaskInStorage(task)
        } catch {
            presenter?.didDeleteTask(error)
        }
        presenter?.didDeleteTask(nil)
    }
}
