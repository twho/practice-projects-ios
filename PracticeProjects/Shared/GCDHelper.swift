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
    /**
     Run on the main thread. This method is used for test override.
     
     - Parameter block: The block to be executed asynchronously.
     */
    func runOnMainThread(_ block: @escaping Block) {
        DispatchQueue.main.async {
            block()
        }
    }
    /**
     Run on the main thread after specified delay. This method is used for test override.
     
     - Parameter delay: The delay time to wait before executing the block.
     - Parameter block: The block to be executed asynchronously.
     */
    func runOnMainThreadAfter(delay: Double, _ block: @escaping Block) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            block()
        }
    }
}
