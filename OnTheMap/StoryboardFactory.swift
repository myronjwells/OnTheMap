//
//  StoryboardFactory.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/5/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import UIKit


//Factory for instantiating storyboard viewcontrollers
struct StoryboardFactory {
  
    static func loginViewController() -> LoginViewController? {
    
        return UIStoryboard(name: "LoginViewController", bundle: nil).instantiateViewController(withIdentifier: "sb_login") as? LoginViewController
    }
    
    static func studentLocationMapViewController() -> UINavigationController? {
    
        return UIStoryboard(name: "StudentLocationMap", bundle: nil).instantiateViewController(withIdentifier: "sb_studentLocationMap") as? UINavigationController
    }
    
    static func studentLocationTableViewController() -> UINavigationController? {
    
        return UIStoryboard(name: "StudentLocationTable", bundle: nil).instantiateViewController(withIdentifier: "sb_studentLocationTable") as? UINavigationController
    }
    
    static func addNewLocationViewController() -> AddNewLocationViewController? {
    
        return UIStoryboard(name: "AddNewLocation", bundle: nil).instantiateViewController(withIdentifier: "sb_addNewLocation") as? AddNewLocationViewController
    }
    
    static func addLocationMapViewController() -> AddLocationMapViewController? {
    
        return UIStoryboard(name: "AddLocationMap", bundle: nil).instantiateViewController(withIdentifier: "sb_addLocationMap") as? AddLocationMapViewController
    }
    
}
