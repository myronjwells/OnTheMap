//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/25/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit

class StudentLocationTableViewController: OnTheMapBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var studentLocations: [StudentLocation] = []
    
    override func viewDidLoad() {
         super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        self.studentLocations = self.appDelegate.studentLocations
     }
    
    
    // MARK: - Table view data source

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations.count
    }
    
    //Create custom cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnTheMapCell") as! OnTheMapCustomCell
        
        let student = self.studentLocations[indexPath.row]
        
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
        
        if let urlString = self.studentLocations[indexPath.row].mediaURL {
            guard let url =  URL(string: urlString) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        
    }
}
