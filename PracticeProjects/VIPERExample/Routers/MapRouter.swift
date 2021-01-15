//
//  MapRouter.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

import UIKit

class MapRouter: NSObject, MapRouterProtocol {
    
    static func createMapModule() -> UIViewController {
        let view: MapViewProtocol & UIViewController = MapViewController()
        let presenter: MapPresenterProtocol & MapInteractorOutputProtocol = MapPresenter()
        let interactor: MapInteractorInputProtocol = MapInteractor()
        let localDataManager: MapLocalDataManagerInputProtocol = MapLocalDataManager()
        let router: MapRouterProtocol = MapRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.localDataManager = localDataManager
        return view
    }
}
