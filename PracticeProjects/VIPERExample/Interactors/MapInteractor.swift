//
//  MapInteractor.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/14/21.
//

class MapInteractor: MapInteractorInputProtocol {
    weak var presenter: MapInteractorOutputProtocol?
    var localDataManager: MapLocalDataManagerInputProtocol?
    
    func retrieveFavoritePlaces() -> [Place] {
        return []
    }
}
