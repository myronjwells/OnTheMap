//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/2/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    
    let username: String
    let password: String
    let completeLoginObject: [String: [String: String]]
    
    
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        self.completeLoginObject = ["udacity": ["username":"\(username)","password": "\(password)"]]
    }

}
