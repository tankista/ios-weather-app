//
//  APISuccess.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//


import Foundation

struct WeatherData : DictionaryRepresentable {
    
    var id: Int64
    var name: String
    var cod: Int64
    var dt: Date
    
    //var visibility: Int64
    
    public init(rawDict: NSDictionary) throws {
        id = rawDict.int64Value("id")
        name = rawDict.stringValue("name")
        cod = rawDict.int64Value("cod")
        dt = rawDict.dateValue("dt")
    }
    
    public var dictionary: NSDictionary {
        fatalError("not needed")
    }
}

