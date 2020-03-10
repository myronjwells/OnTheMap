//
//  AddNewLocationViewController.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/26/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit
import MapKit

class AddNewLocationViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    var userData = UserData(lastName: "", firstName: "")
    var mapController: AddLocationMapViewController = AddLocationMapViewController()
    //MARK: Storyboard Outlets
    
    @IBOutlet weak var locationEntryField: UITextField!
    @IBOutlet weak var websiteEntryField: UITextField!
    
    
    // MARK: UIViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        mapController = StoryboardFactory.addLocationMapViewController()!
        
    }
    //MARK: Storboard Button Actions
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    @IBAction func findLocation(_ sender: Any) {
        
        _ = OTMClient.getUserData() { userData, error in
            
            if let userData = userData {
                self.appDelegate.userData = userData
                self.userData = userData
            } else {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "An error has occured with retrieving user data. Please try again.")
            }
        }
        
        // Check Against Empty Fields
        guard let locationEntered = locationEntryField.text else {return}
        guard let websiteEntered = websiteEntryField.text else {return}
        
        if(locationEntered.isEmpty) {
            showAlert(title: "Required Field", message: "A location is required.")
        }
        else if(websiteEntered.isEmpty) {
            showAlert(title: "Required Field", message: "A website is required.")
        }
        else {
            
            // Check Valid Website URL
            if(!websiteEntered.hasPrefix("https://") && !websiteEntered.hasPrefix("http://")) {
                showAlert(title: "Invalid Link", message: "Please provide a valid link.")
                return
            }
            

            // Create Map Location Search Request
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = locationEntered
            
            let activeSearch = MKLocalSearch(request: searchRequest)
            activeSearch.start { (response, error) in
                if response == nil
                {
                    self.showAlert(title: "Error", message: "Could not Geocode the string. Please provide a different location")
                }
                else
                {
                    self.mapController.locationData = response
                    self.mapController.websiteURLString = self.websiteEntryField.text!
                    self.navigationController?.pushViewController(self.mapController, animated: true)
        
                }
                
            }
            
        }
    }
    
    
}
