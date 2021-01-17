//
//  UserCardViewModel.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/16/21.
//

class UserCardViewModel {
    var didUpdatePersonData: ((People?) -> Void)?
    private(set) var person: People?
    init(person: People) {
        self.person = person
    }
    /**
     Ready for viewWillAppear
     */
    func ready() {
        didUpdatePersonData?(person)
    }
}
