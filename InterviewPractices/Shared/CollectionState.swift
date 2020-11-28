//
//  CollectionState.swift
//  InterviewPractices
//
//  Created by Michael Ho on 11/27/20.
//

enum CollectionState {
    case loading
    case populated([Any])
    case empty
    case error(Error)
    
    var elements: [Any] {
        switch self {
        case .populated(let elements):
            return elements
        default:
            return []
        }
    }
}
