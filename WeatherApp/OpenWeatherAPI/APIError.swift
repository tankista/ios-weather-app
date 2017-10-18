//
//  APIError.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//

import Foundation

///
/// Value type representing an API error object.
///
/// It is returned by API methods when there was on error on API side, such
/// as missing parameters, or invalid operation etc.
///
struct APIError {
    var code: Int64
    var message: String
}

extension APIError : DictionaryRepresentable {
    
    public init(rawDict: NSDictionary) throws {
        code = rawDict.int64Value("cod")
        message = rawDict.stringValue("message")
    }
    
    public var dictionary: NSDictionary {
        fatalError("not implemented")
    }
}
