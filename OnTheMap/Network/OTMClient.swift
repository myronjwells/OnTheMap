//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/29/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

class OTMClient {

    
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
    
    
    //MARK: Request Methods
    class func taskForGETRequest<ResponseType: Decodable>(urlComp: URLComponents, params: [String: String], responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        
        var urlcomp = urlComp
        //Add params into the url if they are available
        var items = [URLQueryItem]()
        for (key,value) in params {
            items.append(URLQueryItem(name: key, value: value))
        }
        
        items = items.filter{!$0.name.isEmpty}
        
        if !items.isEmpty {
            urlcomp.queryItems = items
        }
        
        print("URL: \(urlcomp.url!)")
        let task = URLSession.shared.dataTask(with: urlcomp.url!) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if (String(data: data, encoding: .utf8)?.hasPrefix(")"))! {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }
            
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(urlComp: URLComponents, params: [String: String],responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var urlcomp = urlComp
        //Add params into the url if they are available
        var items = [URLQueryItem]()
        for (key,value) in params {
            items.append(URLQueryItem(name: key, value: value))
        }
        
        items = items.filter{!$0.name.isEmpty}
        
        if !items.isEmpty {
            urlcomp.queryItems = items
        }
        var request = URLRequest(url: urlcomp.url!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if (String(data: data, encoding: .utf8)?.hasPrefix(")"))! {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForDELETERequest<ResponseType: Decodable>(urlComp: URLComponents,responseType: ResponseType.Type,completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: urlComp.url!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if error != nil { // Handle error…
                return
            }
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
               if (String(data: data, encoding: .utf8)?.hasPrefix(")"))! {
                         let range = 5..<data.count
                         data = data.subdata(in: range)
                     }
                     
                     let decoder = JSONDecoder()
                     do {
                         let responseObject = try decoder.decode(ResponseType.self, from: data)
                         DispatchQueue.main.async {
                             completion(responseObject, nil)
                         }
                     }catch {
                         do {
                             let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                             DispatchQueue.main.async {
                                 completion(nil, errorResponse)
                             }
                         } catch {
                             DispatchQueue.main.async {
                                 completion(nil, error)
                             }
                         }
                     }

        }
        task.resume()
    }
    
    
    
    
    
    class func postNewStudentLocations(studentInfo: StudentInfo,completion: @escaping (StudentLocationPOSTResponse?, Error?) -> Void) {
        let body = studentInfo
        taskForPOSTRequest(urlComp: Endpoints.studentInformation.urlComp, params: [:], responseType: StudentLocationPOSTResponse.self, body: body) { response, error in
            if let response = response {
                
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
        
    }
    
    class func getStudentInformation(completion: @escaping (StudentLocationResults?, Error?) -> Void) {
        taskForGETRequest(urlComp: Endpoints.studentInformation.urlComp, params: [GETParamas.order: "-updatedAt"], responseType: StudentLocationResults.self) { response, error in
            if let response = response {
                completion(response,nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getUserData(completion: @escaping (UserData?, Error?) -> Void) {
       taskForGETRequest(urlComp: Endpoints.getUserData.urlComp, params: [:], responseType: UserData.self) { response, error in
            if let response = response {
                completion(response,nil)
            } else {
                completion(nil, error)
            }
        }
    }
    

    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(username:username, password: password)
        taskForPOSTRequest(urlComp: Endpoints.session.urlComp, params: [:], responseType: SessionResponse.self, body: body.completeLoginObject) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.accountKey = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
          taskForDELETERequest(urlComp: Endpoints.session.urlComp, responseType: LogoutResponse.self) { response, error in
              if let response = response {
                //Not sure if this is how you use the response for the DELETE Method but Basically Im replacing the old SessionID with the Logout Response's new sessionID?
                Auth.sessionId = response.session.id
                  completion(true, nil)
              } else {
                  completion(false, error)
              }
          }
      }
    
}
