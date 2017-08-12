//
//  AppDelegate.swift
//  ExploringRxSwift
//
//  Created by Aleksey Kuznetsov on 12/08/2017.
//  Copyright © 2017 Aleksey Kuznetsov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.tintColor = #colorLiteral(red: 0, green: 0.5569, blue: 0.0824, alpha: 1)
        window!.rootViewController = MainViewController()
        window!.makeKeyAndVisible()
        return true
    }
}
