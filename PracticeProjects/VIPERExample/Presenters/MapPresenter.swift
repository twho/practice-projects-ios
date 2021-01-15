//
//  MapPresenter.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

class MapPresenter: MapPresenterProtocol {
    weak var view: MapViewProtocol?
    
    var interactor: MapInteractorInputProtocol?
    
    var router: MapRouterProtocol?
    
    func viewDidLoad() {
        
    }
}

extension MapPresenter: MapInteractorOutputProtocol {
    
    func onError() {
        
    }
}
