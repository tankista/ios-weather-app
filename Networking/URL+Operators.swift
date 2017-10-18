//
//  NSURL+Operators.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//


import Foundation

public func ==(lhs: URL, rhs: URL) -> Bool {
    return lhs.absoluteString == rhs.absoluteString
}

public func +(lhs: URL, rhs: String) -> URL {
    return lhs.appendingPathComponent(rhs)
}

infix operator +?: AdditionPrecedence

public func +?(lhs: URL, rhs: String?) -> URL {
    
    guard let queryString = rhs else {
        return lhs
    }
    
    guard var components = URLComponents(url: lhs, resolvingAgainstBaseURL: false) else {
        fatalError("could not append URL query for \(lhs.absoluteString)")
    }
    
    components.query = queryString
    
    guard let URL = components.url else {
        fatalError("could not compose final URL for components \(components)")
    }
    
    return URL
}

public func +?(lhs: URL, rhs: [URLQueryItem?]?) -> URL {
    
    guard let queryItems = rhs else {
        return lhs
    }
    
    guard var components = URLComponents(url: lhs, resolvingAgainstBaseURL: false) else {
        fatalError("could not append URL query for \(lhs.absoluteString)")
    }
    
    components.queryItems = queryItems.flatMap { $0 }
    
    guard let URL = components.url else {
        fatalError("could not compose final URL for components \(components)")
    }
    
    return URL
}
