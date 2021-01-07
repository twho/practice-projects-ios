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
    /**
     Be careful with the following dealock operations and avoid them.
     The following blocks should make the app crash immediately.
     
     Note:
     1. sync means the function WILL BLOCK the current thread until it has completed,
     2. async means it will be handled in the background and the function WILL NOT BLOCK the current thread.
     */
    func deadlockExample() {
        /**
         Example 1
         
         In the following scnenario, the second closure is waiting for the first closure
         to complete before it can run, however, the first closure cannot complete until
         the second closure is run since its dispatched synchronously.
         */
        let queue1 = DispatchQueue(label: "this-is-queue-1")
        queue1.sync {
            print("This happens")
            // Submitting block synchously to the current queue results in deadlock.
            queue1.sync {
                print("deadlocked")
            }
            print("This never happens")
        }
        /**
         Example 2
         
         The following code prints "Start" -> "End" -> "This happens"
         The inner block is scheduled to be run on queue2 but it cannot run until current block (already in queue2)
         is done, while the current block is also waiting for the inner block to finish to return as we called it (inner block) synchronously.
         */
        let queue2 = DispatchQueue(label: "this-is-queue-2")
        print("Start")
        queue2.async {
            // Outer block
            print("This happens")
            // Submitting queue synchronously to its current queue.
            queue2.sync {
                // Inner block
                print("deadlocked")
            }
            print("This never happens")
        }
        print("End")
    }
    /**
     A barrier operation example. Used for thread safe properties or a read-write lock.
     */
    func barrierExample() {
        let concurrentQueue = DispatchQueue(label: "this-is-queue-1", attributes: .concurrent)
        // Number that stores the latest value
        var _num = 0
        // This is a readonly number
        var readonlyNumber: Int {
            var newNum = 0
            // Sync the latest value after any operating queue is done
            concurrentQueue.sync {
                newNum = _num
            }
            return newNum
        }
        
        while readonlyNumber < 10 {
            print("Current number: \(readonlyNumber)")
            // Change the number value in async barrier
            concurrentQueue.async(flags: .barrier) {
                _num += 1
            }
        }
    }
}
