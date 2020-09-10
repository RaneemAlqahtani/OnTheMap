//
//  Values.swift
//  OnTheMap 1
//
//  Created by Raneem Alhattlan on 05/09/2020.
//  Copyright © 2020 Raneem Alhattlan. All rights reserved.
//

import Foundation

struct Values  {
    
    struct HeaderKeys {
        static let PARSE_APP_ID = "X-Parse-Application-Id"
        static let PARSE_API_KEY = "X-Parse-REST-API-Key"
        
    }
    
    struct HeaderValues {
        static let PARSE_APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let PARSE_API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct ParameterKeys {
        static let LIMIT = "limit"
        static let SKIP = "skip"
        static let ORDER = "order"
    }
    
    private static let MAIN = "https://onthemap-api.udacity.com/v1"
    static let SESSION = MAIN + "/session"
    static let PUBLIC_USER = MAIN + "/users"
    static let STUDENT_LOCATION = MAIN + "/StudentLocation"
    
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
