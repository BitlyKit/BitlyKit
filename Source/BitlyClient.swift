//
//  BitlyClient.swift
//  Bitly
//
//  Created by Brennan Stehling on 1/4/17.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import Foundation

let BitlyBaseURL                   = "https://api-ssl.bitly.com/"
let BitlyShortenPath               = "/v3/shorten"
let BitlyExpandPath                = "/v3/expand"
let BitlyLoginParameter            = "login"
let BitlyApiKeyParameter           = "apiKey"
let BitlyAccessTokenParameter      = "access_token"
let BitlyLongUrlParameter          = "longUrl"
let BitlyShortUrlParameter         = "shortUrl"
let BitlyFormatParameter           = "format"
let BitlyFormat                    = "json"
let BitlyStatusCodeKey             = "status_code"
let BitlyStatusTextKey             = "status_txt"
let BitlyDataKey                   = "data"
let BitlyExpandKey                 = "expand"
let BitlyURLKey                    = "url"
let BitlyShortURLKey               = "short_url"
let BitlyLongURLKey                = "long_url"

let BitlyStatusOK                  = "OK"
let BitlyErrorDomain               = "BitlyErrorDomain"

/** Bitly Error */
public enum BitlyError : Int {
    /** Incomplete Parameters */
    case incompleteParameters = 101
    /** Failure to Shorten URL */
    case failureToShortenURL = 102
    /** Failure to Expand URL */
    case failureToExpandURL = 103
    /** Unexpected Response from Bitly API */
    case unexpectedResponse = 104
    /** An unknown error occurred. */
    case unknownError = 105
    /** Error with API. */
    case apiError = 106

    var errorDomain: String {
        return BitlyErrorDomain
    }

    var errorCode: Int {
        return rawValue
    }

    var description: String {
        switch self {
        case .incompleteParameters:
            return "Incomplete parameters."
        case .failureToShortenURL:
            return "Failure to shorten URL."
        case .failureToExpandURL:
            return "Failure to expand URL."
        case .unexpectedResponse:
            return "Unexpected response."
        case .apiError:
            return "API error."
        case .unknownError:
            return "Unknown error."
        }
    }

    /// Error type for a given error.
    ///
    /// - Parameter error: error
    /// - Returns: error type
    public static func errorType(error: Error?) -> BitlyError {
        let errorCode = (error as? NSError)?.code ?? BitlyError.unknownError.errorCode
        switch errorCode {
        case BitlyError.incompleteParameters.errorCode:
            return .incompleteParameters
        case BitlyError.failureToShortenURL.errorCode:
            return .failureToShortenURL
        case BitlyError.failureToExpandURL.errorCode:
            return .failureToExpandURL
        case BitlyError.unexpectedResponse.errorCode:
            return .unexpectedResponse
        case BitlyError.apiError.errorCode:
            return .apiError
        default:
            return .unknownError
        }
    }

}

/** Bitly JSON Dictionary */
public typealias BitlyJSONDictionary = [String : Any]

/// Bitly Client for shortening and expanding URLs.
open class BitlyClient : NSObject {

    // MARK: - Public -

    /// Shorten URL using access token.
    ///
    /// - Parameters:
    ///   - url: url
    ///   - accessToken: access token
    ///   - completionHandler: completion handler
    /// - Returns: task
    public class func shorten(url: URL?, accessToken: String?, completionHandler: ((URL?, Error?) -> Swift.Void)? = nil) -> URLSessionTask? {
        guard let completionHandler = completionHandler else {
            return nil
        }

        guard let url = url,
            let accessToken = accessToken else {
            let error = prepareError(bitlyError: .incompleteParameters)
            completionHandler(nil, error)
            return nil
        }

        let parameters = [
            BitlyAccessTokenParameter : accessToken,
            BitlyLongUrlParameter: url.absoluteString,
            BitlyFormatParameter: BitlyFormat
        ]

        return shorten(url: url, parameters: parameters, completionHandler: completionHandler)
    }

    /// Shorten URL using username and API key.
    ///
    /// - Parameters:
    ///   - url: url
    ///   - username: username
    ///   - apiKey: api key
    ///   - completionHandler: completion handler
    /// - Returns: task
    public class func shorten(url: URL?, username: String?, apiKey: String?, completionHandler: ((URL?, Error?) -> Swift.Void)? = nil) -> URLSessionTask? {
        guard let completionHandler = completionHandler else {
            return nil
        }
        guard let url = url,
            let username = username,
            let apiKey = apiKey else {
                let error = prepareError(bitlyError: .incompleteParameters)
                completionHandler(nil, error)
                return nil
        }

        let parameters = [
            BitlyLoginParameter : username,
            BitlyApiKeyParameter : apiKey,
            BitlyLongUrlParameter: url.absoluteString,
            BitlyFormatParameter: BitlyFormat
        ]

        return shorten(url: url, parameters: parameters, completionHandler: completionHandler)
    }

    /// Expand URL with access token.
    ///
    /// - Parameters:
    ///   - url: url
    ///   - accessToken: access token
    ///   - completionHandler: completion handler
    /// - Returns: task
    public class func expand(url: URL?, accessToken: String?, completionHandler: ((URL?, Error?) -> Swift.Void)? = nil) -> URLSessionTask? {
        guard let completionHandler = completionHandler else {
            return nil
        }
        guard let url = url,
            let accessToken = accessToken else {
                let error = prepareError(bitlyError: .incompleteParameters)
                completionHandler(nil, error)
                return nil
        }

        let parameters = [
            BitlyAccessTokenParameter: accessToken,
            BitlyShortUrlParameter: url.absoluteString,
            BitlyFormatParameter: BitlyFormat
        ]

        return expand(url: url, parameters: parameters, completionHandler: completionHandler)
    }

    /// Expand URL using username and API key.
    ///
    /// - Parameters:
    ///   - url: url
    ///   - username: username
    ///   - apiKey: API key
    ///   - completionHandler: completion handler
    /// - Returns: task
    public class func expand(url: URL?, username: String?, apiKey: String?, completionHandler: ((URL?, Error?) -> Swift.Void)? = nil) -> URLSessionTask? {
        guard let completionHandler = completionHandler else {
            return nil
        }
        guard let url = url,
            let username = username,
            let apiKey = apiKey else {
                let error = prepareError(bitlyError: .incompleteParameters)
                completionHandler(nil, error)
                return nil
        }

        let parameters = [
            BitlyLoginParameter : username,
            BitlyApiKeyParameter : apiKey,
            BitlyShortUrlParameter: url.absoluteString,
            BitlyFormatParameter: BitlyFormat
        ]

        return expand(url: url, parameters: parameters, completionHandler: completionHandler)
    }

    // MARK: - Private -

    private class func shorten(url: URL, parameters: [AnyHashable : Any], completionHandler: @escaping ((URL?, Error?) -> Swift.Void)) -> URLSessionTask? {

        let urlString = "\(BitlyBaseURL)\(BitlyShortenPath)"
        guard let apiURL = URL(string: urlString) else {
            fatalError("API URL must be defined.")
        }

        return fetchJsonRequest(url: apiURL, parameters: parameters) { (json, error) in
            if error != nil {
                let error = prepareError(bitlyError: .failureToShortenURL, reason: error?.localizedDescription)
                completionHandler(nil, error)
            }
            else {
                guard let jsonDictionary = json as? BitlyJSONDictionary else {
                    let error = prepareError(bitlyError: .unexpectedResponse)
                    completionHandler(nil, error)
                    return
                }

                if let status = jsonDictionary[BitlyStatusTextKey] as? String,
                    status == BitlyStatusOK,
                    let dataDictionary = jsonDictionary[BitlyDataKey] as? BitlyJSONDictionary,
                    let shortenedUrlString = dataDictionary[BitlyURLKey] as? String,
                    let shortenedURL = URL(string: shortenedUrlString) {
                    completionHandler(shortenedURL, nil)
                }
                else if let error = extractAPIError(jsonDictionary: jsonDictionary) {
                    completionHandler(nil, error)
                }
                else {
                    completionHandler(nil, prepareError(bitlyError: .unexpectedResponse))
                }
            }
        }
    }

    private class func expand(url: URL, parameters: [AnyHashable : Any], completionHandler: @escaping ((URL?, Error?) -> Swift.Void)) -> URLSessionTask? {
        let urlString = "\(BitlyBaseURL)\(BitlyExpandPath)"
        guard let apiURL = URL(string: urlString) else {
            fatalError("API URL must be defined.")
        }

        return fetchJsonRequest(url: apiURL, parameters: parameters) { (json, error) in
            if error != nil {
                let error = prepareError(bitlyError: .failureToExpandURL)
                completionHandler(nil, error)
            }
            else {
                guard let jsonDictionary = json as? BitlyJSONDictionary else {
                    let error = prepareError(bitlyError: .unexpectedResponse)
                    completionHandler(nil, error)
                    return
                }

                if let status = jsonDictionary[BitlyStatusTextKey] as? String,
                    status == BitlyStatusOK,
                    let dataDictionary = jsonDictionary[BitlyDataKey] as? BitlyJSONDictionary,
                    let expandedDictionaries = dataDictionary[BitlyExpandKey] as? [BitlyJSONDictionary],
                    let expandedUrlString = expandedDictionaries.first?[BitlyLongURLKey] as? String,
                    let expandedURL = URL(string: expandedUrlString) {
                    completionHandler(expandedURL, nil)
                }
                else if let error = extractAPIError(jsonDictionary: jsonDictionary) {
                    completionHandler(nil, error)
                }
                else {
                    completionHandler(nil, prepareError(bitlyError: .unexpectedResponse))
                }
            }
        }
    }

    // MARK: - Internal -

    internal class func extractAPIError(jsonDictionary: BitlyJSONDictionary) -> NSError? {
        guard let statusText = jsonDictionary[BitlyStatusTextKey] as? String,
            let statusCode = jsonDictionary[BitlyStatusCodeKey] as? Int,
            statusCode != 200 else {
            return nil
        }
        let reason = "\(statusText) (\(statusCode)))"
        return prepareError(bitlyError: .apiError, reason: reason)
    }

    internal class func fetchJsonRequest(url: URL, parameters: [AnyHashable : Any], completionHandler: ((Any?, Error?) -> Swift.Void)? = nil) -> URLSessionTask? {
        guard let completionHandler = completionHandler else {
            return nil
        }

        guard let url = appendQueryParameters(parameters: parameters, url: url) else {
            fatalError("URL must be defined.")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }

            guard let data = data else {
                fatalError("Data must be defined if there is no error.")
            }

            let json = try? JSONSerialization.jsonObject(with: data, options: [])

            if let json = json {
                DispatchQueue.main.async {
                    completionHandler(json, nil)
                }
            }
            else {
                let error = prepareError(bitlyError: .unexpectedResponse)
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }

        task.resume()

        return task
    }

    internal class func appendQueryParameters(parameters: [AnyHashable : Any], url: URL) -> URL? {
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters.flatMap { (name, value) in
            if let name = name as? String {
                let value = String(describing: value)
                return URLQueryItem(name: name, value: value)
            }
            return nil
        }

        return components?.url
    }

    internal class func prepareError(bitlyError: BitlyError, reason: String? = nil, description: String? = nil) -> NSError {
        var userInfo = [NSLocalizedDescriptionKey : description ?? bitlyError.description]
        if let reason = reason {
            userInfo[NSLocalizedFailureReasonErrorKey] = reason
        }
        return NSError(domain: bitlyError.errorDomain, code: bitlyError.errorCode, userInfo: userInfo)
    }

}
