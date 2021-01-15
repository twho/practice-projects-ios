//
//  Protocols.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import UIKit

protocol MapViewProtocol: class {
    var presenter: MapPresenterProtocol? { get set }
}

protocol MapRouterProtocol: class {
    static func createMapModule() -> UIViewController
}

protocol MapPresenterProtocol: class {
    var view: MapViewProtocol? { get set }
    var interactor: MapInteractorInputProtocol? { get set }
    var router: MapRouterProtocol? { get set }
    
    // View -> Presenter
    func viewDidLoad()
    
}

protocol MapInteractorOutputProtocol: class {
    // Interactor -> Presenter
    func onError()
}

protocol MapInteractorInputProtocol: class {
    var presenter: MapInteractorOutputProtocol? { get set }
    var localDataManager: MapLocalDataManagerInputProtocol? { get set }
    
    // Presenter -> Interactor
    func retrieveFavoritePlaces() -> [Place]
}

protocol MapLocalDataManagerInputProtocol: class {
    // Interactor -> LocalDataManager
}
