//
//  GCDHelper.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/28/20.
//

import UIKit
/**
 GCD stands for Global Central Dispatch. This class provides the functions for
 the app to deal with thread operations.
 */
class GCDHelper {
    // Singleton
    static var shared = GCDHelper()
    init() {}
    typealias Block = (() -> ())
    
    func runOnMainThread(_ block: @escaping Block) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    func runOnMainThreadAfter(delay: Double, _ block: @escaping Block) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            block()
        }
    }
}
