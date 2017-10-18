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
    
    var visibility: Int64
    var weather: [Weather]
    var main: Main
    var wind: Wind
    
    public init(rawDict: NSDictionary) throws {
        id = rawDict.int64Value("id")
        name = rawDict.stringValue("name")
        cod = rawDict.int64Value("cod")
        dt = rawDict.dateValue("dt")
        
        visibility = rawDict.int64Value("visibility")
        
        let weathers: [Weather] = try rawDict.arrayy("weather")
        weather = weathers
        
        main = try Main(rawDict: rawDict.dictionaryValue("main"))
        wind = try Wind(rawDict: rawDict.dictionaryValue("wind"))
    }
    
    public var dictionary: NSDictionary {
        fatalError("not needed")
    }
}

extension WeatherData {
    
    struct Weather : DictionaryRepresentable {
        
        var id: Int64
        var main: String
        var desc: String?
        var icon: String?
        
        public init(rawDict: NSDictionary) throws {
            id = rawDict.int64Value("id")
            main = rawDict.stringValue("main")
            desc = rawDict.string("description")
            icon = rawDict.string("icon")
        }
        
        public var dictionary: NSDictionary {
            fatalError("not needed")
        }
        
    }
    
    struct Main : DictionaryRepresentable {
        
        var temp: Double
        var pressure: Int64
        var humidity: Int64
        
        public init(rawDict: NSDictionary) throws {
            temp = rawDict.doubleValue("temp")
            pressure = rawDict.int64Value("pressure")
            humidity = rawDict.int64Value("humidity")
        }
        
        public var dictionary: NSDictionary {
            fatalError("not needed")
        }
        
    }
    
    struct Wind : DictionaryRepresentable {
        
        var speed: Double
        var deg: Int64
        
        public init(rawDict: NSDictionary) throws {
            speed = rawDict.doubleValue("speed")
            deg = rawDict.int64Value("deg")
        }
        
        public var dictionary: NSDictionary {
            fatalError("not needed")
        }
        
    }
    
}

