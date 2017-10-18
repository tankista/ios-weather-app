//
//  Dictionary.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//


import Foundation

public protocol DictionaryRepresentable {
    init(rawDict: NSDictionary) throws
    var dictionary: NSDictionary { get }
}

//
// MARK: Parsing functions for primitive value types
//

//TODO: update methods to accept keyPaths instead of keys
extension NSDictionary {
    
    public func string(_ keyPath: Key) -> String? {
        return value(forKeyPath: keyPath as! String) as? String
        //return self[key] as? String
    }
    
    public func stringValue(_ key: Key, default: String = "") -> String {
        return string(key) ?? `default`
    }
    
    public func bool(_ key: Key, default: Bool = false) -> Bool {
        return (self[key] as? Bool) ?? `default`
    }
    
    public func int(_ key: Key) -> Int? {
        return self[key] as? Int
    }
    
    public func intValue(_ key: Key, default: Int = 0) -> Int {
        return int(key) ?? `default`
    }
    
    public func int64(_ key: Key) -> Int64? {
        if let number = value(forKeyPath: key as! String) as? NSNumber {
            return number.int64Value
        }
        return nil
    }
    
    public func int64Value(_ key: Key, default: Int64 = 0) -> Int64 {
        return int64(key) ?? `default`
    }
    
    public func float(_ key: Key) -> Float? {
        return self[key] as? Float
    }
    
    public func floatValue(_ key: Key, default: Float = 0) -> Float {
        return float(key) ?? `default`
    }
    
    public func double(_ key: Key) -> Double? {
        return self[key] as? Double
    }
    
    public func doubleValue(_ key: Key, default: Double = 0) -> Double {
        return double(key) ?? `default`
    }
    
    public func number(_ key: Key) -> NSNumber? {
        return self[key] as? NSNumber
    }
    
    public func numberValue(_ key: Key, default: NSNumber = 0) -> NSNumber {
        return number(key) ?? `default`
    }
    
    /// expecting cents
    public func decimal(_ key: Key) -> NSDecimalNumber? {
        return NSDecimalNumber(value: intValue(key) as Int)
    }
    
    /// expecting cents
    public func decimalValue(_ key: Key, default: NSDecimalNumber = 0) -> NSDecimalNumber {
        return decimal(key) ?? `default`
    }
    
    public func dictionary(_ key: Key) -> NSDictionary? {
        return value(forKeyPath: key as! String) as? NSDictionary
        //return self[key] as? NSDictionary
    }
    
    public func dictionaryValue(_ key: Key, default: NSDictionary = NSDictionary()) -> NSDictionary {
        return dictionary(key) ?? `default`
    }
    
    public func array(_ key: Key) -> NSArray? {
        return value(forKeyPath: key as! String) as? NSArray
        //return self[key] as? NSArray
    }
    
    public func arrayValue(_ key: Key, default: NSArray = NSArray()) -> NSArray {
        return array(key) ?? `default`
    }
    
}

//
// MARK: Parsing functions for non primitive value types
//

extension NSDictionary {
    
    public func timeInterval(_ key: Key, default: TimeInterval = 0) -> TimeInterval? {
        if let timeInterval = int64(key) {
            return Double(timeInterval) /// 1000_000
        }
        return nil
    }
    
    public func timeIntervalValue(_ key: Key) -> TimeInterval {
        if let timeInterval = timeInterval(key) {
            return timeInterval
        }
        return 0
    }
    
    public func date(_ key: Key) -> Date? {
        if let timeInterval = timeInterval(key) {
            return Date(timeIntervalSince1970: timeInterval)
        }
        return nil
    }
    
    public func dateValue(_ key: Key) -> Date {
        return Date(timeIntervalSince1970: timeIntervalValue(key))
    }
    
    public func URL(_ key: Key) -> Foundation.URL? {
        
        var urlString = self.stringValue(key)
        if urlString.isEmpty {
            return nil
        }
        else if urlString.contains("http") == false {
            urlString = "http://" + urlString
        }
        
        return Foundation.URL(string: urlString)
    }
    
    public func arrayOfDicts(_ key: Key) -> [NSDictionary] {
        return arrayValue(key).map { $0 as! NSDictionary }
    }
    
    public func arrayy<T>(_ key: Key) throws -> [T] where T: DictionaryRepresentable {
        return try arrayValue(key).map { try T.init(rawDict: $0 as! NSDictionary) }
    }
    
    public func currency(_ key: Key) -> String? {
        return string(key)
    }
    
    public func currencyValue(_ key: Key, default: String = "EUR") -> String {
        if let currencyValue = currency(key) {
            return currencyValue
        }
        return `default`
    }
}

@available(iOS 10.0, *)
private var isoDateFormatter = ISO8601DateFormatter()

extension NSDictionary {
    
    @available(iOS 10.0, *)
    public func ISO8601Date(_ keyPath: Key) -> Date? {
        
        guard let dateString = string(keyPath) else {
            return nil
        }
        
        return isoDateFormatter.date(from: dateString)
    }

    @available(iOS 10.0, *)
    public func ISO8601DateValue(_ keyPath: Key) -> Date {
        return ISO8601Date(keyPath) ?? Date(timeIntervalSince1970: 0)
    }
}

