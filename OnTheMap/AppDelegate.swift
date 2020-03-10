//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/21/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var userData: UserData? = nil
    var studentInformation = [StudentInformation]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
}

