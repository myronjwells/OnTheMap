//
//  Constants.swift
//  OnTheMap
//
//  Created by Myron Wells on 3/11/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

extension OTMClient {

struct Auth {
      static var accountKey = ""
      static var sessionId = ""
  }
  
  enum GETParamas {
      static var limit = "limit"
      static var skip = "skip"
      static var order = "order"
      static var uniqueKey = "uniqueKey"
  }

  enum Endpoints {
      static let base = "https://onthemap-api.udacity.com/v1"
      
      case getUserData
      case studentInformation
      case session
      
      var stringValue: String {
          switch self {
          case .getUserData:
              return Endpoints.base + "/users/\(Auth.accountKey)"
          case .studentInformation:
              return Endpoints.base + "/StudentLocation"
          case .session:
              return Endpoints.base + "/session"
          }
      }
      
      var urlComp: URLComponents {
          return URLComponents(string: stringValue)!
      }
  }
}
