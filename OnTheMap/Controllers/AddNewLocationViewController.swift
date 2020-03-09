//
//  AddNewLocationViewController.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/26/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit
import MapKit

class AddNewLocationViewController: OnTheMapBaseViewController {
    
    @IBOutlet weak var locationEntryField: UITextField!
    @IBOutlet weak var websiteEntryField: UITextField!
    var userData = UserData(lastName: "", firstName: "")
    
    
    var mapController: AddLocationMapViewController = AddLocationMapViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapController = StoryboardFactory.addLocationMapViewController()!
        
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        _ = OTMClient.getUserData() { userData, error in
            
            if let userData = userData {
                
                self.appDelegate.userData = userData
                self.userData = userData
            } else {
                print(error)
            }
        }
        
        // Check Against Empty Fields
        guard let locationEntered = locationEntryField.text else {return}
        guard let websiteEntered = websiteEntryField.text else {return}
        
        if(locationEntered.isEmpty) {
            print("Alert: Must Enter a Location")
        }
        else if(websiteEntered.isEmpty) {
            print("Alert: Must Enter a Website")
        }
        else {
            
            // Check Valid Website URL
            if(!websiteEntered.hasPrefix("https://") && !websiteEntered.hasPrefix("http://")) {
                print("Alert: Invalid Link. Include http(s)://")
            }
            
            
            
            // Create Map Location Search Request
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = locationEntered
            
            let activeSearch = MKLocalSearch(request: searchRequest)
            activeSearch.start { (response, error) in
                if response == nil
                {
                    print("Alert: Could Not Geocode the String.")
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
