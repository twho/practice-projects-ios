//
//  ContactsViewModel.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/16/21.
//

import UIKit

class ContactsViewModel {
    // MARK: Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didCompleteQuery: (([People]) -> Void)?
    var didUpdatePeopleData: (([People]) -> Void)?
    var didFailToUpdatePeopleData: ((Error) -> Void)?
    var readyToPresent: ((UIViewController) -> Void)?
    private var peopleData: [People] = [People]()
    private(set) var visibleData: [People] = [People]() {
        didSet {
            didUpdatePeopleData?(visibleData)
        }
    }
    private let autoQuery = AutoQuery()
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
            self.didUpdatePeopleData?(self.visibleData)
        }
    }
    /**
     Did select row in the table view.
     
     - Parameter indexPath: The selected index path.
     */
    func didSelectRow(_ indexPath: IndexPath) {
        guard indexPath.row < visibleData.count else { return }
        let userCardVC = UserCardViewController(viewModel: UserCardViewModel(person: visibleData[indexPath.row]))
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
