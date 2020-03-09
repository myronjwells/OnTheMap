//
//  OnTheMapBaseViewController.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/7/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit

class OnTheMapBaseViewController: UIViewController {


    var appDelegate: AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
    }
    @IBAction func addStudentTapped(_ sender: Any) {
        
        
        let addNewLocationVC = StoryboardFactory.addNewLocationViewController()!
        let addStudentNavigationController = UINavigationController(rootViewController: addNewLocationVC)
        self.present(addStudentNavigationController, animated: true, completion: nil)
    }

}
