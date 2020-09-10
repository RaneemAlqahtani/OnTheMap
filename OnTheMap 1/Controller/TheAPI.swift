//
//  Session.swift
//  OnTheMap 1
//
//  Created by Raneem Alhattlan on 05/09/2020.
//  Copyright © 2020 Raneem Alhattlan. All rights reserved.
//

import Foundation

class TheAPI {
    
    private static var userInformation = UserInformation()
    private static var sessionId: String?
    
    
    
    static func postTheSession(username: String, password: String, completion: @escaping (String?)->Void) {
        
        guard let sessionURL = URL(string: Values.SESSION) else {
            completion("The URL is invalid")
            return
        }
        
        var request = URLRequest(url: sessionURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //json Object
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errorMessage: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode < 400 { //Response is ok
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dict = json as? [String:Any],
                        let sessionDict = dict["session"] as? [String: Any],
                        let accountDict = dict["account"] as? [String: Any]  {
                        self.userInformation.key = accountDict["key"] as? String
                        self.sessionId = sessionDict["id"] as? String
                        
                        self.getUserInformation(completion: { error in
                            
                        })
                    } else {
                        errorMessage = "Can't parse response"
                    }
                } else {
                    errorMessage = "Wrong Email or Password"
                }
            } else {
                errorMessage = "Check the internet connection"
            }
            DispatchQueue.main.async {
                completion(errorMessage)
            }
            
        }
        task.resume()
    }
    
    
    static func deleteTheSession(completion: @escaping (String?) -> Void){
        guard let sessionURL = URL(string: Values.SESSION) else {
            completion("The URL is invalid")
            return
        }
        var request = URLRequest(url:sessionURL)
        var xCookie: HTTPCookie? = nil
        let CookieStorage = HTTPCookieStorage.shared
        for cookie in CookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xCookie = cookie}
        }
        if let x_Cookie = xCookie {
            request.setValue(x_Cookie.value, forHTTPHeaderField: "X-XSFR-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request){ data , response , error in
            if error != nil {
                return
            }
            if (data?.count ?? 0) > 5, let newData = data?.subdata(in: 5..<data!.count){
                print(String(data: newData , encoding: .utf8)! )
            }
            DispatchQueue.main.async {
                completion(nil)
            }
            
        }
        task.resume()
    }
    
    
    static func getUserInformation(completion: @escaping (Error?)->Void) {
        guard let userId = userInformation.key , let urlGetUser = URL(string: "\(Values.PUBLIC_USER)\(userId)") else {
            completion(NSError(domain: "URLError", code: 0, userInfo: nil))
            return
        }
        var request = URLRequest(url: urlGetUser)
        request.addValue(self.sessionId! , forHTTPHeaderField: "session_id")
        let session = URLSession.shared
        let task = session.dataTask(with: request) {data , response, error in
            var firstName: String?, lastName: String?, nickname: String = ""
            if let statusCode = (response as? HTTPURLResponse)? . statusCode, statusCode < 400 { 
                let newInfo = data?.subdata(in: 5..<data!.count)
                if let json = try? JSONSerialization.jsonObject(with: newInfo!, options: []),
                    let js = json as? [String:Any]{
                    
                    nickname = js["nickname"] as? String ?? ""
                    firstName = js["first_name"] as? String ?? nickname
                    lastName = js["last_name"] as? String ?? nickname
                    
                    userInformation.firstName = firstName
                    userInformation.lastName = lastName
                }
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
            
        }
        
        task.resume()
        
    }
    
    static func getStudentLocations(limit: Int = 100, skip: Int = 0, orderBy: SLParam = .updatedAt, completion: @escaping (Locations?)->Void) {
        guard let url = URL(string: "\(Values.STUDENT_LOCATION)?\(Values.ParameterKeys.LIMIT)=\(limit)&\(Values.ParameterKeys.SKIP)=\(skip)&\(Values.ParameterKeys.ORDER)=-\(orderBy.rawValue)") else {
            completion(nil)
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(Values.HeaderValues.PARSE_APP_ID, forHTTPHeaderField: Values.HeaderKeys.PARSE_APP_ID)
        request.addValue(Values.HeaderValues.PARSE_API_KEY, forHTTPHeaderField: Values.HeaderKeys.PARSE_API_KEY)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var locationsData: Locations?
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode < 400 { //Response is ok
                    
                    do {
                        locationsData = try JSONDecoder().decode(Locations.self, from: data!)
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(locationsData)
            }
            
        }
        task.resume()
    }
    
    
    
    static func postLocation(_ location: StudentLocation, completion: @escaping (String?)->Void) {
        guard let accountId = userInformation.key , let url = URL(string: "\(Values.STUDENT_LOCATION)") else {
            completion("There is an error!")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue(Values.HeaderValues.PARSE_APP_ID, forHTTPHeaderField: Values.HeaderKeys.PARSE_APP_ID)
        request.addValue(Values.HeaderValues.PARSE_API_KEY, forHTTPHeaderField: Values.HeaderKeys.PARSE_API_KEY)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.httpBody = "{\"uniqueKey\": \"\(accountId)\", \"firstName\": \"\("John")\", \"lastName\": \"\("Doe")\",\"mapString\": \"\(location.mapString!)\", \"mediaURL\": \"\(location.mediaURL!)\",\"latitude\": \(location.latitude!), \"longitude\": \(location.longitude!)}".data(using: .utf8)
        
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){ data, response , error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 400 {
                    errString = "Can't post the location"
                }
            }else{
                errString = "Check the internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
        }
        
        task.resume()
    }
    
}








