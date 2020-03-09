//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Myron Wells on 2/29/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

class OTMClient {
    
    //    static let apiKey = "0ceaa5e08229bb193a2c4da5ba03b26b"
    //
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
    }
    //
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        //static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getUserData
        case studentLocations
        //        case getFavorites
        //        case getRequestToken
        //        case login
        case createSessionId
        //        case logout
        //        case webAuth
        //        case search(String)
        //        case markWatchlist
        //        case markFavorite
        //        case posterImage(String)
        
        var stringValue: String {
            switch self {
            case .getUserData:
                return Endpoints.base + "/users/\(Auth.accountKey)"
            case .studentLocations:
                return Endpoints.base + "/StudentLocation"
                //            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                //            case .getFavorites:
                //                return Endpoints.base + "/account/\(Auth.accountId)/favorite/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                //            case .getRequestToken:
                //                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
                //            case .login:
            //                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .createSessionId:
                return Endpoints.base + "/session"
                //            case .logout:
                //                return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
                //            case .webAuth:
                //                return "https://www.themoviedb.org/authenticate/\(Auth.requestToken)?redirect_to=themoviemanager:authenticate"
                //            case .search(let query):
                //                return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
                //            case .markWatchlist:
                //                return Endpoints.base + "/account/\(Auth.accountId)/watchlist" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                //            case .markFavorite:
                //                return Endpoints.base + "/account/\(Auth.accountId)/favorite" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                //            case .posterImage(let posterPath):
                //                return "https://image.tmdb.org/t/p/w500/" + posterPath
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
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
    
    class func postNewStudentLocations(studentInfo: StudentInfo,completion: @escaping (StudentLocationPOSTResponse?, Error?) -> Void) {
        let body = studentInfo
        taskForPOSTRequest(url: Endpoints.studentLocations.url, responseType: StudentLocationPOSTResponse.self, body: body) { response, error in
            if let response = response {
                
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
        
    }
    
    class func getStudentLocations(completion: @escaping (StudentLocationResults?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.studentLocations.url, responseType: StudentLocationResults.self) { response, error in
            if let response = response {
                completion(response,nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getUserData(completion: @escaping (UserData?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData.url, responseType: UserData.self) { response, error in
            if let response = response {
                completion(response,nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
    
    //    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
    //        taskForGETRequest(url: Endpoints.getWatchlist.url, responseType: MovieResults.self) { response, error in
    //            if let response = response {
    //                completion(response.results, nil)
    //            } else {
    //                completion([], error)
    //            }
    //        }
    //    }
    //
    //    class func getFavorites(completion: @escaping ([Movie], Error?) -> Void) {
    //        taskForGETRequest(url: Endpoints.getFavorites.url, responseType: MovieResults.self) { response, error in
    //            if let response = response {
    //                completion(response.results, nil)
    //            } else {
    //                completion([], error)
    //            }
    //        }
    //    }
    //
    //    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
    //        taskForGETRequest(url: Endpoints.getRequestToken.url, responseType: RequestTokenResponse.self) { response, error in
    //            if let response = response {
    //                Auth.requestToken = response.requestToken
    //                completion(true, nil)
    //            } else {
    //                completion(false, error)
    //            }
    //        }
    //    }
    //
    //    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    //        let body = LoginRequest(username: username, password: password, requestToken: Auth.requestToken)
    //        taskForPOSTRequest(url: Endpoints.login.url, responseType: RequestTokenResponse.self, body: body) { response, error in
    //            if let response = response {
    //                Auth.requestToken = response.requestToken
    //                completion(true, nil)
    //            } else {
    //                completion(false, error)
    //            }
    //        }
    //    }
    //
    
    
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(username:username, password: password)
        taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body.completeLoginObject) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.accountKey = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    //
    //    class func logout(completion: @escaping () -> Void) {
    //        var request = URLRequest(url: Endpoints.logout.url)
    //        request.httpMethod = "DELETE"
    //        let body = LogoutRequest(sessionId: Auth.sessionId)
    //        request.httpBody = try! JSONEncoder().encode(body)
    //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //        let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //            Auth.requestToken = ""
    //            Auth.sessionId = ""
    //            completion()
    //        }
    //        task.resume()
    //    }
    //
    //    class func search(query: String, completion: @escaping ([Movie], Error?) -> Void) -> URLSessionDataTask {
    //        let task = taskForGETRequest(url: Endpoints.search(query).url, responseType: MovieResults.self) { response, error in
    //            if let response = response {
    //                completion(response.results, nil)
    //            } else {
    //                completion([], error)
    //            }
    //        }
    //        return task
    //    }
    //
    //    class func markWatchlist(movieId: Int, watchlist: Bool, completion: @escaping (Bool, Error?) -> Void) {
    //        let body = MarkWatchlist(mediaType: "movie", mediaId: movieId, watchlist: watchlist)
    //        taskForPOSTRequest(url: Endpoints.markWatchlist.url, responseType: TMDBResponse.self, body: body) { response, error in
    //            if let response = response {
    //                // separate codes are used for posting, deleting, and updating a response
    //                // all are considered "successful"
    //                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
    //            } else {
    //                completion(false, nil)
    //            }
    //        }
    //    }
    //
    //    class func markFavorite(movieId: Int, favorite: Bool, completion: @escaping (Bool, Error?) -> Void) {
    //        let body = MarkFavorite(mediaType: "movie", mediaId: movieId, favorite: favorite)
    //        taskForPOSTRequest(url: Endpoints.markFavorite.url, responseType: TMDBResponse.self, body: body) { response, error in
    //            if let response = response {
    //                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
    //            } else {
    //                completion(false, nil)
    //            }
    //        }
    //    }
    //
    //    class func downloadPosterImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
    //        let task = URLSession.shared.dataTask(with: Endpoints.posterImage(path).url) { data, response, error in
    //            DispatchQueue.main.async {
    //                completion(data, error)
    //            }
    //        }
    //        task.resume()
    //    }
    
}
