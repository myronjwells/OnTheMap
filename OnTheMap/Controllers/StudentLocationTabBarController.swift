//
//  StudentLocationTabBarController.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/5/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit

class StudentLocationTabBarController: UITabBarController {

override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tabBar.barStyle = .black
    
    let mapStyleController = StoryboardFactory.studentLocationMapViewController()!
    let tableStyleController = StoryboardFactory.studentLocationTableViewController()!
    
    mapStyleController.tabBarItem.image = UIImage(named: "icon_mapview-deselected")
    mapStyleController.tabBarItem.selectedImage = UIImage(named: "icon_mapview-selected")
    
    tableStyleController.tabBarItem.image = UIImage(named: "icon_listview-deselected")
    tableStyleController.tabBarItem.selectedImage = UIImage(named: "icon_listview-selected")
    
    self.viewControllers = [mapStyleController,tableStyleController]
    
    
}


}
