//
//  APISuccess.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//


import Foundation

/////
///// Value type representing an API response object for POST requests.
/////
//struct APISuccess<T: DictionaryRepresentable> {
//    var result: T
//    var kind: String
//    var etag: String
//}
//
//extension APISuccess : DictionaryRepresentable {
//    
//    public init(rawDict: NSDictionary) throws {
//        result = try T.init(rawDict: rawDict)
//        kind = rawDict.stringValue("kind")
//        etag = rawDict.stringValue("etag")
//    }
//    
//    public var dictionary: NSDictionary {
//        fatalError("not implemented")
//    }
//}

