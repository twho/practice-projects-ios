//
//  HitTestViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 12/20/20.
//

import UIKit

class HitTestViewController: UIViewController {
    /**
     The order that we add the views are:
     1. blueView
        1.1. button1
        1.2. button2
     2. pinkView
        2.1. button3
        2.2. button4
     3. yellowView
        3.1. button5
        3.2. button6
     (See xib file for view hierarchy.)
     
     Example:
         When we click button1, the traverse order is as the following:
         yellowView -> pinkView -> blueView -> Button2 -> Button1
     */
    // UIViews
    @IBOutlet weak var blueView: HitTestView!
    @IBOutlet weak var pinkView: HitTestView!
    @IBOutlet weak var yellowView: HitTestView!
    // UIButtons
    @IBOutlet weak var button1: HitTestButton!
    @IBOutlet weak var button2: HitTestButton!
    @IBOutlet weak var button3: HitTestButton!
    @IBOutlet weak var button4: HitTestButton!
    @IBOutlet weak var button5: HitTestButton!
    @IBOutlet weak var button6: HitTestButton!
    
    private var latest = 0
    private var visited = Set<String>()
    private var stackTrace = [String]() {
        didSet {
            self.latest += 1
            let timeStamp = self.latest
            DispatchQueue.main.async {[weak self] in
                // Print out after the last element is appended to the stack trace.
                guard let self = self, self.latest == timeStamp else { return }
                print(self.stackTrace)
                self.stackTrace = []
                self.visited = []
                self.latest = 0
            }
        }
    }
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = self.addNavigationBar(title: Constants.Example.hitTest.title,
                                  rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close"), style: .done, target: self, action: #selector(self.backToPreviousVC)))
        [button1, button2, button3, button4, button5, button6].forEach {
            $0.hitTestVC = self
        }
        [blueView, pinkView, yellowView].forEach {
            $0?.hitTestVC = self
        }
        blueView.name = "blueView"
        pinkView.name = "pinkView"
        yellowView.name = "yellowView"
    }
    /**
     Add a log to stack trace.
     
     - Parameter log: The name of the view hit by hit test.
     */
    func addLog(_ log: String) {
        if !visited.contains(log) {
            self.stackTrace.append(log)
            self.visited.insert(log)
        }
    }
}
