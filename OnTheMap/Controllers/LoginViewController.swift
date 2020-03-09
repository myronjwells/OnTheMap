//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/22/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        
        OTMClient.createSessionId(username: emailTextField.text ?? "" , password: passwordTextField.text ?? "", completion: handleSessionResponse(success:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hidesBarsOnTap = true
        // Do any additional setup after loading the view.
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        //setLoggingIn(false)
        if success {

            let studentLocationTabBarController = StudentLocationTabBarController()
            studentLocationTabBarController.modalPresentationStyle = .fullScreen
            self.present(studentLocationTabBarController, animated: true, completion: nil)
            
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
