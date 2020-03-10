//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/25/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit

class StudentLocationTableViewController: OnTheMapBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Fields
    @IBOutlet var tableView: UITableView!
    var studentInformation: [StudentInformation] = []
    
    
    // MARK: UIViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    // MARK: Helper Methods
    override func loadData() {
        self.showSpinner(onView: self.view)
        _ = OTMClient.getStudentInformation() { studentLocationResults, error in
            
            if let studentInformation = studentLocationResults?.results {
                //Persist the results in the appDelegates Structure for future use
                self.appDelegate.studentInformation = studentInformation
                self.studentInformation = self.appDelegate.studentInformation
                self.tableView.reloadData()
                self.removeSpinner()
            }
        }
        
    }
    
    // MARK: - TableView Data Source Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentInformation.count
    }
    
    //Create custom cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnTheMapCell") as! OnTheMapCustomCell
        
        let student = self.studentInformation[indexPath.row]
        
        let firstName = student.firstName
        let lastName = student.lastName
        
        if(firstName != nil || lastName != nil) {
            let fullName = "\(firstName ?? "") \(lastName ?? "")"
            cell.nameLabel.text = fullName
            cell.mediaURLLabel.text = student.mediaURL
        }
        
        return cell
    }
    
    //Change Default height for dynamic cells
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    //Handle Selection on tap to redirect to provided url
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let urlString = self.studentInformation[indexPath.row].mediaURL {
            guard let url =  URL(string: urlString) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        
    }
}
