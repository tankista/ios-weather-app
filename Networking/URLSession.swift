//
//  NSURLSession.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//


import Foundation

public struct HTTPMethod {
    public static var GET: String = "GET"
    public static var POST: String = "POST"
}

///
/// Error type that is used for custom http wrapper methods.
///
public enum HTTPError : Error {
    ///
    /// json could not be parsed or loaded properly
    ///
    case invalidData(dataError: HTTPResponseDataError)
    ///
    /// 400 bad request
    ///
    case badRequest
    ///
    /// 401 request was not authorised
    ///
    case unauthorised
    ///
    /// 403
    ///
    case forbidden
    ///
    /// 404
    ///
    case resourceNotFound
    ///
    /// 405
    ///
    case methodNotAllowed
    ///
    /// 415
    ///
    case unsupportedMediaTypes
    ///
    /// 500 The server encountered an unexpected condition which prevented it from fulfilling the request.
    ///
    case internalServerError
    ///
    /// unknown
    ///
    case unknownError(description: String?)
    
}

///
/// Error that is used when parsing/processing response of NSURLSession task.
///
public enum HTTPResponseDataError : Error {
    ///
    /// No response is returned, data is nil
    ///
    case noResponse
    ///
    /// Data is a json format but unexpected.
    ///
    case unexpectedJSON(desc: String)
    ///
    /// Data is not a json format
    ///
    case notAJson
    ///
    /// If parsing block thrown an unknown error. Should throw HTTPResponseDataError error
    ///
    case unknownError
}

extension URLSession {
    
    // MARK: Public Methods
    
    ///
    /// Wrapper func that returns NSURLSession task with some basic work done.
    ///
    /// - Note: Please note that `parsingHandler` block must throw `HTTPResponseDataError` error type if there is a parsing error. Otherwise it will be evaluated as `HTTPResponseDataError.UnknownError`
    ///
    public func httpTaskWithURLRequest<T, U>(_ request: URLRequest, parsingHandler: @escaping (_ jsonObject: AnyObject, _ error: HTTPError?) throws -> (T?, U?), completion: @escaping (AnyObject?, T?, URLResponse?, (U?, HTTPError?)?) -> Void) -> URLSessionDataTask {
        return dataTask(with: request, completionHandler: { (data, response, error) in
            URLSession.processResponse(data, response: response, error: error, parsing: parsingHandler, completion: completion)
        })
    }
    
    public static func httpTaskWithURLRequest<T, U>(_ request: URLRequest, parsingHandler: @escaping (_ jsonObject: AnyObject, _ error: HTTPError?) throws -> (T?, U?), completion: @escaping (AnyObject?, T?, URLResponse?, (U?, HTTPError?)?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.httpTaskWithURLRequest(request, parsingHandler: parsingHandler, completion: completion)
    }
    
    ///
    /// Wrapper func that returns NSURLSession task with some basic work done.
    ///
    /// - Note: Please note that `parsingHandler` block must throw `HTTPResponseDataError` error type if there is a parsing error. Otherwise it will be evaluated as `HTTPResponseDataError.UnknownError`
    ///
    public func httpTaskWithURL<T, U>(_ url: URL, parsingHandler: @escaping (_ jsonObject: AnyObject, _ error: HTTPError?) throws -> (T?, U?), completion: @escaping (AnyObject?, T?, URLResponse?, (U?, HTTPError?)?) -> Void) -> URLSessionDataTask {
        return dataTask(with: url, completionHandler: { (data, response, error) in
            URLSession.processResponse(data, response: response, error: error, parsing: parsingHandler, completion: completion)
        })
    }
    
    public static func httpTaskWithURL<T, U>(_ url: URL, parsingHandler: @escaping (_ jsonObject: AnyObject, _ error: HTTPError?) throws -> (T?, U?), completion: @escaping (AnyObject?, T?, URLResponse?, (U?, HTTPError?)?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.httpTaskWithURL(url, parsingHandler: parsingHandler, completion: completion)
    }
    
    public static func queryString(fromParams params: [String: String]?) -> String {
        
        guard let params = params else {
            return ""
        }
        
        var queryItems = [URLQueryItem]()
        for key in params.keys {
            queryItems.append(URLQueryItem(name: key, value: params[key]))
        }
        var components = URLComponents()
        components.queryItems = queryItems
        
        return components.query ?? ""
    }
    
    // MARK: Private Methods
    
    fileprivate static func parseJSONObject(_ data: Data?) throws -> AnyObject {
        
        guard let data = data , data.count > 0 else {
            throw HTTPResponseDataError.noResponse
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            throw HTTPResponseDataError.notAJson
        }
        
        return json as AnyObject
    }
    
    fileprivate static func processResponse<T, U>(_ data: Data?, response: URLResponse?, error: Error?, parsing: (_ jsonObject: AnyObject, _ error: HTTPError?) throws -> (T?, U?), completion: (AnyObject?, T?, URLResponse?, (U?, HTTPError?)?) -> Void) -> Void {
        
        var parsingResult: (model: T?, error: U?)
        var jsonObject: AnyObject?
        var processError: HTTPError?
        
        //let str = String(data: data!, encoding: String.Encoding.utf8)
        //print(str!)
        //log.debug("response: \(data?.count ?? 0) bytes")
        
        if let response = response as? HTTPURLResponse {
            
            switch response.statusCode {
            case 200:
                processError = nil
            case 400:
                processError = .badRequest
            case 401:
                processError = .unauthorised
            case 403:
                processError = .forbidden
            case 404:
                processError = .resourceNotFound
            case 405:
                processError = .methodNotAllowed
            case 415:
                processError = .unsupportedMediaTypes
            case 500:
                processError = .internalServerError
            default:
                processError = .unknownError(description: error?.localizedDescription)
            }

            do {
                jsonObject = try parseJSONObject(data)
                parsingResult = try parsing(jsonObject!, processError)
                //print(jsonObject!)
            }
            catch let responseDataError {
                let rawResponse = String(data: data ?? Data(), encoding: String.Encoding.utf8)
                print(rawResponse ?? "")
                //log.verbose(rawResponse ?? "empty string")
                
                if let knownError = responseDataError as? HTTPResponseDataError {
                    processError = HTTPError.invalidData(dataError: knownError)
                }
                else {
                    processError = HTTPError.invalidData(dataError: .unknownError)
                }
            }
        }
        else if let error = error {
            processError = HTTPError.unknownError(description: error.localizedDescription)
        }
        
        var error: (U?, HTTPError?)? = (parsingResult.error, processError)
        if error?.0 == nil && error?.1 == nil {
            error = nil
        }
        
        completion(jsonObject, parsingResult.model, response, error)
    }
}
