//
//  HTTPResponseParser.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//

import Foundation

///
/// Parses a raw network json object into specified ObjectType or array of ObjectTypes.
///
/// If you know that response should be a dictionary use `parseDictionary` func, if
/// it's array of objects use `parseArray` func instead.
///
struct HTTPResponseParser {
    
    ///
    /// A raw json object returned from network that should be parsed
    ///
    var jsonObject: AnyObject?
    
    ///
    /// A HTTP error that is provided from networking layer
    ///
    var httpError: HTTPError?
    
    ///
    /// Converts raw json object to provided type `T`, if error occures an error object of type `U` is returned.
    /// Use this method if you know that json response is dictionary. If it's array use the method below.
    ///
    /// - parameter keyPath: Object that is parsed will be looked up through this key path
    ///
    func parseDictionary<T: DictionaryRepresentable, U: DictionaryRepresentable>(keyPath: String? = nil) throws -> (T?, U?) {
        
        if let error: U = try parseHTTPError() {
            return (nil, error)
        }
        
        if let path = keyPath {
            guard let jsonObject = jsonObject?.value(forKeyPath: path) as? NSDictionary else {
                throw HTTPResponseDataError.unexpectedJSON(desc: "response JSON was not expected format for key path \(path)")
            }
            return (try T.init(rawDict: jsonObject), nil)
        }
        else {
            guard let jsonObject = jsonObject as? NSDictionary else {
                throw HTTPResponseDataError.unexpectedJSON(desc: "response JSON was not expected format")
            }
            return (try T.init(rawDict: jsonObject), nil)
        }
    }
    
    ///
    /// Converts raw json object to array of type `T`, if error occures an error object of type `U` is returned.
    /// Use this method if you know that json response is array. If it's dictionary use the method above.
    ///
    /// - parameter keyPath: Array that is parsed will be looked up through this key path
    ///
    func parseArray<T: DictionaryRepresentable, U: DictionaryRepresentable>(keyPath: String? = nil) throws -> ([T]?, U?) {
        
        if let error: U = try parseHTTPError() {
            return (nil, error)
        }
        
        let jsonArray: [NSDictionary]
        
        if let path = keyPath {
            guard let object = jsonObject?.value(forKeyPath: path) as? [NSDictionary] else {
                throw HTTPResponseDataError.unexpectedJSON(desc: "response JSON was not expected format of array of raw dict")
            }
            
            jsonArray = object
        }
        else {
            guard let object = jsonObject as? [NSDictionary] else {
                throw HTTPResponseDataError.unexpectedJSON(desc: "response JSON was not expected format of array of raw dict")
            }
            
            jsonArray = object
        }
        
        let results = try jsonArray.map { try T.init(rawDict: $0) }
        return (results, nil)
    }
    
    private func parseHTTPError<U: DictionaryRepresentable>() throws -> U? {
        
        guard let error = httpError else {
            return nil
        }
        
        guard let jsonDict = jsonObject as? NSDictionary else {
            throw HTTPResponseDataError.unexpectedJSON(desc: "encountered error but could not read json data \(error)")
        }
        
        return try U.init(rawDict: jsonDict)
    }
}
