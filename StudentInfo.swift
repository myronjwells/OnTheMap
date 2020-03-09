//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/9/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

struct StudentInfo: Codable {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    
    init() {
        
        self.uniqueKey = ""
        self.firstName = ""
        self.lastName = ""
        self.mapString = ""
        self.mediaURL = ""
        self.latitude = 0.0
        self.longitude = 0.0
    }
}
