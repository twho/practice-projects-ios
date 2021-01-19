//
//  ContactsViewModel.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/16/21.
//

import UIKit

class ContactsViewModel {
    // MARK: MVVM Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didCompleteQuery: (([People]) -> Void)?
    var didUpdatePeopleData: ((Bool) -> Void)?
    var didFailToUpdatePeopleData: ((Error) -> Void)?
    var readyToPresent: ((UIViewController) -> Void)?
    // Private use
    private var peopleData: [People] = [People]()
    private(set) var visibleData: [People] = [People]() {
        didSet {
            didUpdatePeopleData?(visibleData.count != 0)
        }
    }
    // Set internal for test override
    var autoQuery = AutoQuery()
    /**
     The URL we are using to fetch data for this demo. The original JSON file is also included
     at the path - RestAPIExample/PeopleSample.json in case the web service is not working.
     */
    private let urlString = "https://jsonplaceholder.typicode.com/users"
    // MARK: Inputs
    /**
     Ready for viewWillAppear
     */
    func ready() {
        isRefreshing?(true)
        RestAPIHelper.fetch(urlString, People.self, nil) { [weak self] result in
            guard let self = self else { return }
            do {
                self.completeDownloading(with: try result.get())
            } catch {
                self.didFailToUpdatePeopleData?(error)
            }
        }
    }
    /**
     Handle query in the current data.
     
     - Parameter query: The quert string.
     */
    func didChangeQuery(_ query: String) {
        autoQuery.performAutoQuery { [weak self] in
            guard let self = self else { return }
            self.visibleData = query.isEmpty ? self.peopleData : self.peopleData.filter { $0.personName.contains(query)}
            self.didUpdatePeopleData?(self.visibleData.count != 0)
        }
    }
    /**
     
     
     */
    func cellForRow(at indexPath: IndexPath) -> SingleContactViewModel? {
        guard indexPath.row < visibleData.count else { return nil }
        return SingleContactViewModel(person: visibleData[indexPath.row])
    }
    /**
     Did select row in the table view.
     
     - Parameter indexPath: The selected index path.
     */
    func didSelectRow(at indexPath: IndexPath) {
        guard indexPath.row < visibleData.count else { return }
        let userCardVC = UserCardViewController(viewModel: SingleContactViewModel(person: visibleData[indexPath.row]))
        readyToPresent?(userCardVC)
    }
    /**
     Complete dowloading from internet.
     
     - Parameter peopleData: The people data downloaded from internet.
     */
    func completeDownloading(with peopleData: [People]) {
        isRefreshing?(false)
        self.peopleData = peopleData
        self.visibleData = peopleData
    }
    // MARK: Test override
    func getGCDHelperInContext() -> GCDHelper {
        return GCDHelper.shared
    }
}
