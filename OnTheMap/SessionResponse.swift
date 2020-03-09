//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/2/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

struct SessionResponse:Codable {

    let account: Account
    let session: Session
}

struct Account: Codable {
    
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id :String
    let expiration:String
}
