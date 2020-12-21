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
            hitTestVC!.addLog(self.titleLabel?.text ?? self.description)
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
            if let name = self.name {
                hitTestVC!.addLog(name)
            } else {
                hitTestVC!.addLog(self.description)
            }
            
        }
        return super.hitTest(point, with: event)
    }
}
