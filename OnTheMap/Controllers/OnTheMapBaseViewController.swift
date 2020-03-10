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
        loadData()
    }
    
    //MARK: Button Actions
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        
        loadData()
    }
    @IBAction func addStudentTapped(_ sender: Any) {
        
        
        let addNewLocationVC = StoryboardFactory.addNewLocationViewController()!
        let addStudentNavigationController = UINavigationController(rootViewController: addNewLocationVC)
        self.present(addStudentNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        OTMClient.logout(completion: handleLogoutResponse(success:error:))
    }
    
    //MARK: Helper Methods
    func handleLogoutResponse(success: Bool, error: Error?) {
        
        if success {
            //Logged Out
            print("Logging Out...")
            let logInVC = StoryboardFactory.loginViewController()
            logInVC?.modalPresentationStyle = .fullScreen
            self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Logout Failed",message: error?.localizedDescription ?? "")
        }
    }
    
    func loadData() {
        fatalError("\(#function) was not implemented")
    }
}
