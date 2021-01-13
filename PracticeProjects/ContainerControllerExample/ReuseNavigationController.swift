//
//  ReuseNavigationController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/10/21.
//

import UIKit

class ReuseNavigationController: UINavigationController {
    var viewControllerCaches = [String : UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = self.addNavigationBar(title: Constants.Example.containerController.title,
                                      rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close"), style: .done, target: self, action: #selector(self.backToPreviousVC)))
    }
    
    func pushReusableViewController(to viewControllerType: AnyClass, animated: Bool) {
        var canReuse = false
        for vc in self.viewControllers {
            if vc.isKind(of: viewControllerType) {
                if let poppedViewControllers = self.popToViewController(vc, animated: animated) {
                    for archivedVC in poppedViewControllers {
                        viewControllerCaches[String(describing: type(of: archivedVC))] = archivedVC
                    }
                }
                canReuse = true
                break
            }
        }
        
        if !canReuse {
            var nextViewController: UIViewController?
            if let vc = viewControllerCaches[String(describing: viewControllerType)] {
                // Prepare the view for reuse, update content if needed.
                nextViewController = vc
                viewControllerCaches[String(describing: viewControllerType)] = nil
            } else if let newVC = viewControllerType as? UIViewController.Type {
                nextViewController = newVC.init()
            }
            self.pushViewController(nextViewController.unsafelyUnwrapped, animated: animated)
        }
    }
}
