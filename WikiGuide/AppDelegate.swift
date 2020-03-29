//
//  AppDelegate.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let dependencyManager = DependencyManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        dependencyManager.setupContainer(as: .normal)
        
        let mapVC = window?.rootViewController as! MapVC
        mapVC.setupDependencies(with: dependencyManager)
        
        return true
    }

}

