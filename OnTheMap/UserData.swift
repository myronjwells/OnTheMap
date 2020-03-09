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
    
    


//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        firstName = try container.decode(String.self, forKey: .firstName)
//        lastName = try container.decode(String.self, forKey: .lastName)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(firstName, forKey: .firstName)
//        try container.encode(lastName, forKey: .lastName)
//        try container.encode(fullName, forKey: .fullName)
//    }
}


