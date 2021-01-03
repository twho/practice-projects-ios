//
//  HitTestView.swift
//  PracticeProjects
//
//  Created by Michael Ho on 12/20/20.
//

import UIKit

class HitTestButton: UIButton {
    weak var hitTestVC: HitTestViewController?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if hitTestVC != nil {
            hitTestVC!.addLog(self.titleLabel?.text ?? self.description, self.responderChain())
            
        }
        self.cancelTracking(with: event)
        return super.hitTest(point, with: event)
    }
}

class HitTestView: UIView {
    weak var hitTestVC: HitTestViewController?
    var name: String?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if hitTestVC != nil {
            hitTestVC!.addLog(self.name ?? self.description, self.responderChain())
        }
        return super.hitTest(point, with: event)
    }
}

extension UIResponder {
    
    func responderChain() -> String {
        let nextString = next == nil ? "" : " -> " +  next!.responderChain()
        if let hitTestView = self as? HitTestView {
            return (hitTestView.name ?? hitTestView.description) + nextString
        } else if let hitTestButton = self as? HitTestButton {
            return (hitTestButton.titleLabel?.text ?? hitTestButton.description) + nextString
        }
        return "\(type(of: self))" + nextString
    }
}
