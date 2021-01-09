//
//  HitTestViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 12/20/20.
//
// Reference: https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/using_responders_and_the_responder_chain_to_handle_events

import UIKit

class HitTestViewController: UIViewController {
    /**
     The order that we add the views are:
     1. blueView
        1.1. button1
        1.2. button2
     2. pinkView
        2.1. textField
        2.2. button3
        2.3. button4
     3. yellowView
        3.1. button5
        3.2. button6
     (See xib file for view hierarchy.)
     
     Hit test example:
         When we click button1, the traverse order is as the following:
         yellowView -> pinkView -> blueView -> Button2 -> Button1
     
     Responder chain example:
         When we click textField, the responder chain looks like the following:
         HitTestTextField -> UIStackView -> pinkView -> UIView -> HitTestViewController -> MenuViewController ->
         UITransitionView -> UIWindow -> UIWindowScene -> UIApplication -> AppDelegate
     
     Explain: Since the textField does not handle the event, UIKit sends the event to its parent view, followed by the root
     view of the window. From the root view, the responder chain diverts to the owning view controller before directing the
     event to the window. If the window cannot handle the event, UIKit delivers the event to the UIApplication, and possibly
     to the app delegate if that object is an instance of UIResponder and not already part of the responder chain.
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
    @IBOutlet weak var textField: HitTestTextField!
    
    private var latestStack = 0
    private var visited = Set<String>()
    private var stackTrace = [String]() {
        didSet {
            self.latestStack += 1
            let timeStamp = self.latestStack
            DispatchQueue.main.async {[weak self] in
                // Print out after the last element is appended to the stack trace.
                guard let self = self, self.latestStack == timeStamp else { return }
                print(self.stackTrace)
                self.stackTrace = []
                self.visited = []
                self.latestStack = 0
            }
        }
    }
    private var latestOutput = 0
    private var responderChain: String = "" {
        didSet {
            self.latestOutput += 1
            let timeStamp = self.latestOutput
            DispatchQueue.main.async {[weak self] in
                // Print out after the last element is appended to the stack trace.
                guard let self = self, self.latestOutput == timeStamp else { return }
                print("Responder chain: \(self.responderChain)")
                self.latestOutput = 0
            }
        }
    }
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = self.addNavigationBar(title: Constants.Example.hitTestResponder.title,
                                  rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close"), style: .done, target: self, action: #selector(self.backToPreviousVC)))
        [button1, button2, button3, button4, button5, button6].forEach {
            $0.hitTestVC = self
        }
        [blueView, pinkView, yellowView].forEach {
            $0?.hitTestVC = self
        }
        textField.hitTestVC = self
        blueView.name = "blueView"
        pinkView.name = "pinkView"
        yellowView.name = "yellowView"
    }
    /**
     Add a hit test log to stack trace.
     
     - Parameter log: The name of the view hit by hit test.
     */
    func addLog(_ log: String, _ responderChain: String) {
        if !visited.contains(log) {
            self.stackTrace.append(log)
            self.visited.insert(log)
            self.responderChain = responderChain
        }
    }
}
