//
//  API.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//


import Foundation
import MapKit

///
/// OpenWeather services API
///
final class API {
    
    typealias Error = (api: APIError?, http: HTTPError?)

    lazy var session: URLSession = {
        return URLSession(configuration: .`default`, delegate: self.sessionDelegate, delegateQueue: nil)
    }()
    
    var baseURL: URL
    var APIPrefix: String
    var version: String
    var APIKey: String
    
    var sessionDelegate: URLSessionDelegate? = nil //this is strong intentionally
    
    init(baseURL: URL, APIPrefix: String, version: String, APIKey: String) {
        self.baseURL = baseURL
        self.APIPrefix = APIPrefix
        self.version = version
        self.APIKey = APIKey
    }
    
    func getCurrentWeather(by coordinate: CLLocationCoordinate2D, completion: @escaping (_ data: WeatherData?, _ error: API.Error?) -> Void) -> URLSessionTask {
        let params: [URLQueryItem] = [
            URLQueryItem(name: "lat", value: String(describing: coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(describing: coordinate.longitude)),
            URLQueryItem(name: "appid", value: APIKey)
        ]
        let url = baseURL + APIPrefix + version + "weather" +? params
        let request = urlRequest(urlPath: url, params: nil, headers: nil, method: HTTPMethod.GET)
        return dictionaryDataTask(request: request, responseObjectKeyPath: nil, response: completion)
    }
    
}

extension API {
    
    ///
    /// Creates a URLSession data task that parses returned object into array of objects of type `T`, if failed to error of type `U`.
    ///
    fileprivate func arrayDataTask<T: DictionaryRepresentable, U: DictionaryRepresentable>(request: URLRequest, responseObjectKeyPath: String? = nil, responseQueue: DispatchQueue = DispatchQueue.main, response: @escaping (_ data: [T]?, _ error: (U?, HTTPError?)?) -> Void) -> URLSessionTask {
        
        // create parsing handler that returns parsed objects or error
        let parsingHandler: (AnyObject, HTTPError?) throws -> ([T]?, U?) = { (jsonObject, httpError) -> ([T]?, U?) in
            let parser = HTTPResponseParser(jsonObject: jsonObject, httpError: httpError)
            return try parser.parseArray(keyPath: responseObjectKeyPath)
        }
        
        // completion block that is called when request is returned and finished parsing
        let completion: (AnyObject?, [T]?, URLResponse?, (U?, HTTPError?)?) -> Void = { (_, parsedObject, _, error) in
            responseQueue.async(execute: { response(parsedObject, error) })
        }
        
        return session.httpTaskWithURLRequest(request, parsingHandler: parsingHandler, completion: completion)
    }
    
    ///
    /// Creates a URLSession data task that parses returned dictionary into array of type `T`, if failed to error of type `U`.
    ///
    fileprivate func dictionaryDataTask<T: DictionaryRepresentable, U: DictionaryRepresentable>(request: URLRequest, responseObjectKeyPath: String? = nil, responseQueue: DispatchQueue = DispatchQueue.main, response: @escaping (_ data: T?, _ error: (U?, HTTPError?)?) -> Void) -> URLSessionTask {
        
        // create parsing handler that returns parsed objects or error
        let parsingHandler: (AnyObject, HTTPError?) throws -> (T?, U?) = { (jsonObject, httpError) -> (T?, U?) in
            let parser = HTTPResponseParser(jsonObject: jsonObject, httpError: httpError)
            return try parser.parseDictionary(keyPath: responseObjectKeyPath)
        }
        
        // completion block that is called when request is returned and finished parsing
        let completion: (AnyObject?, T?, URLResponse?, (U?, HTTPError?)?) -> Void = { (_, parsedObject, _, error) in
            responseQueue.async(execute: { response(parsedObject, error) })
        }
        
        return session.httpTaskWithURLRequest(request, parsingHandler: parsingHandler, completion: completion)
    }
    
    ///
    /// Convenience method to create a basic url request
    ///
    fileprivate func urlRequest(urlPath: URL, params: [String: String]?, headers: [String: String]?, method: String) -> URLRequest {
        
        var request = URLRequest(url: urlPath)
        
        //hardcoded headers
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        
        //add custom headers
        headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        request.httpMethod = method
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 30
        
        return request
    }

}
