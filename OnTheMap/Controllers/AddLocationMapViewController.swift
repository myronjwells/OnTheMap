//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/26/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: OnTheMapBaseViewController {
    var locationData : MKLocalSearch.Response?
    var websiteURLString: String = ""
    var coordinate : CLLocationCoordinate2D!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
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
    
    @IBAction func finishTapped(_ sender: Any) {
        
        var newStudent = createStudentWithCoords(coordinate: coordinate)
    
        OTMClient.postNewStudentLocations(studentInfo: newStudent) { response, error in
            var test = response
        }
        //
        //        //PUT data to Student Location array
        //
        //          //add the variables needed in the StudentLocation.swift file at the top and then pass inside the AddStudentLocation struct created
        //
        //          AddStudentLocation.init(studentLocation: ["uniqueKey":"12345678", "firstName":"Aapple","lastName":"Doe","mapString":"Mountain View, CA", "mediaURL":"https://udacity.com","latitude": 37.386052,"longitude": -122.083851]).execute(
        //
        //              onSuccess: { (hs: StudentLocation) in
        //                //move pages back to map
        //          },
        //              onError: { (error: Error) in error.printDescription()}
        //          )
    }
    
    func createStudentWithCoords(coordinate: CLLocationCoordinate2D) -> StudentInfo {
        var studentInfo =  StudentInfo()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        lookUpLocation(location: location) { placeMark in
           DispatchQueue.main.async {
              studentInfo.mapString = getCityNameCountryString(placeMark: placeMark)
            }
        }
                studentInfo.firstName = self.appDelegate.userData!.firstName
                studentInfo.lastName = self.appDelegate.userData!.lastName
                studentInfo.latitude = coordinate.latitude
                studentInfo.longitude = coordinate.longitude
                studentInfo.mediaURL = websiteURLString
    
        return studentInfo
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
                 // An error occurred during geocoding.
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

