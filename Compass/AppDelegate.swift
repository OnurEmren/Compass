//
//  AppDelegate.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        
        window?.rootViewController = appCoordinator.navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

