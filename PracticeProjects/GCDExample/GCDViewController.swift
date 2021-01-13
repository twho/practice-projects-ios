//
//  GCDViewController.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/10/21.
//

import UIKit

class GCDViewController: UIViewController {
    let queue = DispatchQueue(label: "custom-queue")
    let concurrentQueue = DispatchQueue(label: "concurrent-queue", attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = self.addNavigationBar(title: Constants.Example.GCDExample.title,
                                      rightBarItem: UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close"), style: .done, target: self, action: #selector(self.backToPreviousVC)))
        /**
         Examples
         1. deadlockExample1()
         2. deadlockExample2()
         3. barrierExample()
         4. dispatchGroupExample()
         5. dispatchGroupNotifyExample()
        
         Pending
         1. Semaphores
         */
        print("Put a break point on this line to check out below examples.")
    }
    /**
     Be careful with the following dealock operations and avoid them.
     The following blocks should make the app crash immediately.
     
     Note:
     1. sync means the function WILL BLOCK the current thread until it has completed,
     2. async means it will be handled in the background and the function WILL NOT BLOCK the current thread.
     */
    private func deadlockExample1() {
        /**
         Example 1
         
         In the following scnenario, the second closure is waiting for the first closure
         to complete before it can run, however, the first closure cannot complete until
         the second closure is run since its dispatched synchronously.
         */
        queue.sync {
            print("custom-queue: This happens")
            // Submitting block synchously to the current queue results in deadlock.
            queue.sync {
                print("custom-queue: deadlocked")
            }
            print("custom-queue: This never happens")
        }
    }
    /**
     Another deadlock example
     */
    private func deadlockExample2() {
        /**
         Example 2
         
         The following code prints "Start" -> "End" -> "This happens"
         The inner block is scheduled to be run on queue2 but it cannot run until current block (already in queue2)
         is done, while the current block is also waiting for the inner block to finish to return as we called it (inner block) synchronously.
         */
        print("custom-queue: Start")
        queue.asyncAndWait(execute: DispatchWorkItem(block: { [weak self] in
            guard let self = self else { return }
            // Outer block
            print("custom-queue: This happens")
            // Submitting queue synchronously to its current queue.
            self.queue.sync {
                // Inner block
                print("custom-queue: deadlocked")
            }
            print("custom-queue: This never happens")
            
        }))
        print("End")
    }
    /**
     A barrier operation example. Used for thread safe properties or a read-write lock.
     */
    private func barrierExample() {
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
                // Use sleep to simulate task delay.
                sleep(UInt32(1))
                _num += 1
            }
        }
        print("All tasks are done.")
    }
    /**
     Dispatch groups can group together multiple tasks and wait for them to complete.
     Tasks can be asynchronous or synchronous and can even run on different queues.
     
     Note: the number of enter() calls must be the same as the number of leave() calls or the app will crash.
     */
    private func dispatchGroupExample() {
        // Normally we can just do DispatchQueue.global(qos: .userInitiated).async. We use async and wait since
        // we want to see the print outs here.
        DispatchQueue.global(qos: .userInitiated).asyncAndWait(execute: DispatchWorkItem(block: { [weak self] in
            guard let self = self else { return }
            let workGroup = DispatchGroup()
            for i in 0..<10 {
                workGroup.enter()
                print("workGroup enters task \(i)")
                self.dummyWorkItem {
                    workGroup.leave()
                    print("workGroup leaves task \(i)")
                }
                
            }
            // This synchronous wait method blocks the current thread.
            workGroup.wait()
            print("workGroup has completed all tasks")
            // Use for UI updates.
            // DispatchQueue.main.async {}
        }))
    }
    /**
     In another way, dispatch groups can group together multiple tasks and receive a notification once they complete.
     In this method, we don't need to put the code in async block.
     */
    private func dispatchGroupNotifyExample() {
        let workGroup = DispatchGroup()
        for i in 0..<10 {
            workGroup.enter()
            print("workGroup enters task \(i)")
            self.dummyWorkItem {
                workGroup.leave()
                print("workGroup leaves task \(i)")
            }
            
        }
        workGroup.notify(queue: DispatchQueue.main) {
            // Also Use for UI updates.
            // Release the break point to see this block run.
            print("workGroup has completed all tasks")
        }
    }
    /**
     Simulate network tasks with a delay of 1000ms.
     */
    private func dummyWorkItem(_ completion: (() -> ())?) {
        sleep(UInt32(1))
        completion?()
    }
}
