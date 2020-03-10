//
//  UserData.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/8/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation


struct UserData:Codable {
    
    let lastName: String
    let firstName: String
        
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }

}


