//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/22/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextViewDelegate {
    
    //MARK: Storyboard Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpTextView: UITextView!
    
    //MARK: Button Actions
    @IBAction func loginTapped(_ sender: Any) {
        
        OTMClient.login(username: emailTextField.text ?? "" , password: passwordTextField.text ?? "", completion: handleSessionResponse(success:error:))
    }
    
    // MARK: UIViewController LifeCycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hidesBarsOnTap = true
        formatSignUpText()
    }
    
    //MARK: Helper Methods
    
    func formatSignUpText() {
        
        let attributedText = NSMutableAttributedString(string: signUpTextView.text)
               let paragraph = NSMutableParagraphStyle()
               paragraph.alignment = .center
               let attributes: [NSAttributedString.Key: Any] = [
                   .font: UIFont.systemFont(ofSize: 14),
                   .paragraphStyle: paragraph,
               ]
               attributedText.addAttributes(attributes, range: NSRange(location: 0, length: attributedText.length))
               attributedText.addAttribute(.link, value: "https://auth.udacity.com/sign-up", range: NSRange(location: 23, length: 8))
               signUpTextView.attributedText = attributedText
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {

        if success {

            let studentLocationTabBarController = StudentLocationTabBarController()
            studentLocationTabBarController.modalPresentationStyle = .fullScreen
            self.present(studentLocationTabBarController, animated: true, completion: nil)
            
        } else {
            showAlert(title: "Login Failed",message: error?.localizedDescription ?? "")
        }
    }
    
    
    
    //MARK: UITextView Delegate Methods
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    
}
