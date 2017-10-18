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
    var message: String
    var code: Int64
    var errors: [UnderlyingError]
}

extension APIError : DictionaryRepresentable {
    
    public init(rawDict: NSDictionary) throws {
        message = rawDict.stringValue("error.message")
        code = rawDict.int64Value("error.code")
        errors = try rawDict.arrayy("error.errors")
    }
    
    public var dictionary: NSDictionary {
        fatalError("not implemented")
    }
}

extension APIError {

    struct UnderlyingError {
        var domain: String
        var reason: String
        var message: String
    }

}

extension APIError.UnderlyingError : DictionaryRepresentable {

    init(rawDict: NSDictionary) throws {
        domain = rawDict.stringValue("domain")
        reason = rawDict.stringValue("reason")
        message = rawDict.stringValue("message")
    }
    
    var dictionary: NSDictionary {
        fatalError("not implemented")
    }
}
