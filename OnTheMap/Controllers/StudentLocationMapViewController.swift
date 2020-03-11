//
//  StudentLocationMapViewController.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/25/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationMapViewController: OnTheMapBaseViewController, MKMapViewDelegate {
    
    // MARK: Fields
    
    @IBOutlet weak var mapView: MKMapView!
   
   //MARK: Helper Methods
   override func loadData() {
    self.showSpinner(onView: self.view)
    _ = OTMClient.getStudentInformation() { studentLocationResults, error in
        
               self.removeSpinner()
               if let studentInformation = studentLocationResults?.results {
                   //Persist the results in the Students Model for future use
                   Students.shared.results = studentInformation
                   self.generateMapAnnotationsFromStudentLocations(Students.shared.results)

               } else {
                
                self.showAlert(title: "Error", message: "Could not retrieve student list data.")
                debugPrint(error?.localizedDescription as Any)
                
            }
              
           }
           
    }
    
    func generateMapAnnotationsFromStudentLocations(_ locations: [StudentInformation]) {
        //clear out annotations
        mapView.removeAnnotations(mapView.annotations)
        
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName ?? "") \(location.lastName ?? "")"
            
            if let mediaURL = location.mediaURL {
                annotation.subtitle = mediaURL
            }
            annotations.append(annotation)
            
            //print(coordinate)
        }
        
        self.mapView.addAnnotations(annotations)
        
        
    }
    
    //MARK: MKMapView Delegate Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: {
                    (success) in
                    print("Open \(toOpen): \(success)")
                })
            }
            
        }
    }
    
}
