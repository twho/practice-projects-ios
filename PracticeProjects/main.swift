//
//  main.swift
//  PracticeProjects
//
//  Created by Michael Ho on 11/26/20.
//

import UIKit

let appDelegateClass: AnyClass = NSClassFromString("MockAppDelegate") ?? AppDelegate.self

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(appDelegateClass)
)
