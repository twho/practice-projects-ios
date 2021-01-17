//
//  AutoQuery.swift
//  PracticeProjects
//
//  Created by Michael Ho on 1/16/21.
//

import UIKit

class AutoQuery {
    private var queryTask: DispatchWorkItem?
    
    func performAutoQuery(delay: Double = 0.5, queryBlock: @escaping () -> Void) {
        if let startQuery = self.queryTask {
            startQuery.cancel()
        }
        self.queryTask = DispatchWorkItem {
            guard let queryTask = self.queryTask, !queryTask.isCancelled else { return }
            queryBlock()
        }
        getGCDHelperInContext().runOnMainThreadAfter(delay: delay) {
            self.queryTask?.perform()
        }
    }
    // Test override
    func getGCDHelperInContext() -> GCDHelper {
        return GCDHelper.shared
    }
}
