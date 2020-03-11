//
//  StudentsModel.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/11/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

class Students {
    
    // MARK: - Properties
    
    static let shared = Students()
    
    var results: [StudentInformation]
    
    private init(){
        self.results = []
    }
    
}
