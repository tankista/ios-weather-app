//
//  URLRequest+Curl.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//

import Foundation

extension URLRequest {
    
    ///
    /// Examines url request and generates curl representation that can be used in console
    /// for debugging purposes.
    ///
    public func curlRepresentation() -> String {
        
        let newLine = "\n"
        var string = "curl -s -X \(httpMethod ?? "unknown") '\(url?.absoluteString ?? "unknown")'"
        
        if let data = httpBody {
            if let dataString = String.init(data: data, encoding: String.Encoding.utf8) {
                string += newLine + "--data '\(dataString)'"
            }
        }
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                string += newLine + "--header '\(key):\(value)'"
            }
        }
        return string
    }
    
}
