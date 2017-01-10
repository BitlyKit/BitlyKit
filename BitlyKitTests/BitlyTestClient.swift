//
//  BitlyTestClient.swift
//  Bitly
//
//  Created by Brennan Stehling on 1/9/17.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import Foundation
@testable import BitlyKit

class BitlyTestClient: BitlyClient {

    static var json: Any?
    static var error: Error?

    override class func fetchJsonRequest(url: URL, parameters: [AnyHashable : Any], completionHandler: ((Any?, Error?) -> Swift.Void)? = nil) -> URLSessionTask? {
        guard let completionHandler = completionHandler else {
            return nil
        }

        if let json = json {
            completionHandler(json, nil)
        }
        else if let error = error {
            completionHandler(nil, error)
        }
        else {
            let error = prepareError(bitlyError: .unknownError)
            completionHandler(nil, error)
        }

        // it is not necessary to return a real task for tests
        return nil
    }

}
