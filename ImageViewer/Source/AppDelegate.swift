//
//  AppDelegate.swift
//  ImageViewer
//
//  Created by Valerii Kotsulym on 9/19/19.
//  Copyright © 2019 Valerii Kotsulym. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

