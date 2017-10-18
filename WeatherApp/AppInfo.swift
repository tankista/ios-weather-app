//
//  AppInfo.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//

import Foundation

struct AppInfo {
    
    static let baseURLForAPI = URL(for: "APIBaseURL")
    static let prefixForAPI = string(for: "APIPrefix")
    static let versionForAPI = string(for: "APIVersion")
    static let appIdForAPI = string(for: "APIAPPID")
    
    ///
    /// General func to obtain URL value from info.plist file
    ///
    static func URL(for key: String) -> URL {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String, let url = Foundation.URL(string: value) else {
            fatalError("could not load value for \(key) from info.plist")
        }
        return url
    }
    
    ///
    /// General func to obtain string value from info.plist file
    ///
    static func string(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("could not load value for \(key) from info.plist")
        }
        return value
    }
    
    ///
    /// Returns app version as it's saved in info.plist (1, 1.0, 1.0.1)
    ///
    static var versionShort: String {
        return string(for: "CFBundleShortVersionString")
    }
    
    ///
    /// Returns app version always in x.y.z format
    ///
    static var version: String {
        //supports x.y.z so lets check if there is 1.y and suplement missing .z or .y.z
        let version = versionShort
        let exploded = version.components(separatedBy: ".")
        switch exploded.count {
        case 1: return version + ".0.0"
        case 2: return version + ".0"
        case 3: return version
        default: return "0.0.0"
        }
    }
    
    ///
    /// Bundle version, we use this as build number
    ///
    static var bundleVersion: String {
        return string(for: kCFBundleVersionKey as String)
    }
    
    ///
    /// Returns version with bundle version in format version.bundleVersion (1.x.y.z)
    ///
    static var versionFull: String {
        return "\(version).\(bundleVersion)"
    }
}
