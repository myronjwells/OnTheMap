//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/5/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

struct ErrorResponse:Codable {

    let status: Int
    let error: String?
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
