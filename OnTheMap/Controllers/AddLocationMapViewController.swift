//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/26/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController {
    // MARK: Fields
    
    var locationData : MKLocalSearch.Response?
    var websiteURLString: String = ""
    var coordinate : CLLocationCoordinate2D!
    var appDelegate: AppDelegate!
    var newStudentInfo =  StudentInfo()
    
    // MARK: Storyboard Outlets
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Storyboard Button Actions
    
    @IBAction func finishTapped(_ sender: Any) {
        self.showSpinner(onView: self.view)
        OTMClient.postNewStudentLocations(studentInfo: newStudentInfo) { response, error in
            if response != nil {
                self.removeSpinner()
                self.navigationController?.dismiss(animated: true)
                
            } else {
                self.showAlert(title: "Student Edit Failed", message: error?.localizedDescription ?? "There was an issue. Please go over the provided data and try again.")
            }
        }
    }
    
    // MARK: UIViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        setUp()
        createStudentWithCoords(coordinate: coordinate)
    }
    // MARK: Helper Methods
    
    func setUp() {
        
        let latitude = locationData?.boundingRegion.center.latitude
        let longitude = locationData?.boundingRegion.center.longitude
        
        //Create annotation
        let annotation = MKPointAnnotation()
        let fullname = "\(self.appDelegate.userData!.firstName) \(self.appDelegate.userData!.lastName)"
        annotation.title = fullname
        annotation.subtitle = websiteURLString
        annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        self.mapView.addAnnotation(annotation)
        
        //Zooming in on annotation
        coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    
    func createStudentWithCoords(coordinate: CLLocationCoordinate2D) {
        getStudentMapString(latitude: coordinate.latitude, longitude: coordinate.longitude)
        newStudentInfo.uniqueKey = OTMClient.Auth.accountKey
        newStudentInfo.firstName = self.appDelegate.userData!.firstName
        newStudentInfo.lastName = self.appDelegate.userData!.lastName
        newStudentInfo.latitude = coordinate.latitude
        newStudentInfo.longitude = coordinate.longitude
        newStudentInfo.mediaURL = websiteURLString
    }
    
    
    func getStudentMapString(latitude:Double,longitude:Double) {

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        var mapString = ""
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

             // City
               if let city = placeMark.locality {
                   mapString += "\(city), "
               }
               // State
               if let state = placeMark.administrativeArea {
                   mapString += "\(state), "
               }
               
               // Country
               if let country = placeMark.country {
                   mapString += country
               }
            
            self.newStudentInfo.mapString = mapString
        
        })
    }
    
    
    func lookUpLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let placemark = placemarks?.first
                                                completionHandler(placemark)
                                            }
                                            else {
                                                completionHandler(nil)
                                            }
        })
    }
    
}

func getCityNameCountryString(placeMark: CLPlacemark?) -> String {
    
    var fullCityStateCountryString = ""
    
    // Place details
    guard let placeMark = placeMark else { return "" }
    
    // City
    if let city = placeMark.locality {
        fullCityStateCountryString += "\(city), "
    }
    // State
    if let state = placeMark.administrativeArea {
        fullCityStateCountryString += "\(state), "
    }
    
    // Country
    if let country = placeMark.country {
        fullCityStateCountryString += country
    }
    
    return fullCityStateCountryString
}

