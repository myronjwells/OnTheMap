//
//  UserDataModel.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/11/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

class User {
    
    // MARK: - Properties
    
    static let shared = User()
    
    var data: UserData
    
    private init(){
        self.data = UserData(lastName: "LastName", firstName: "FirstName")
    }
    
}
