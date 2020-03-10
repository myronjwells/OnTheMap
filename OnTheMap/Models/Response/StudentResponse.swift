//
//  StudentResponse.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/2/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation



struct StudentLocationResults:Codable {
    let results: [StudentInformation]
}

struct StudentInformation:Codable {
    
    let objectId: String
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double
    var longitude: Double
    var createdAt: String
    var updatedAt: String

}

