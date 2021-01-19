//
//  SimpleTableViewCell.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/18/21.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {
    private var viewModel: SingleContactViewModel
    
    init(viewModel: SingleContactViewModel, reuseIdentifier: String) {
        self.viewModel = viewModel
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        viewModel.didUpdatePersonData = { [weak self] (person) in
            guard let self = self else { return }
            self.textLabel?.text = person.personName
            self.detailTextLabel?.text = person.phone
        }
        viewModel.ready()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
