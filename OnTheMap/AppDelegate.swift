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
    var sessionID: String? = nil
    var accountKey: String? = nil
    var userData: UserData? = nil
    
    var studentLocations = [StudentLocation]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
}

