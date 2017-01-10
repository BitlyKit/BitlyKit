//
//  BitlyTests.swift
//  BitlyTests
//
//  Created by Brennan Stehling on 1/4/17.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import XCTest
@testable import Bitly
@testable import BitlyKit

class BitlyTests: XCTestCase {

    var username: String?
    var apiKey: String?
    var accessToken: String?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let defaults = UserDefaults.standard
        username = defaults.object(forKey: UserDefaultUsername) as? String
        apiKey = defaults.object(forKey: UserDefaultApiKey) as? String
        accessToken = defaults.object(forKey: UserDefaultAccessToken) as? String
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - Integration Tests (Requires Credentials) -

    func testRequiredUserDefaults() {
        guard let _ = username,
            let _ = apiKey,
            let _ = accessToken else {
            XCTFail()
            return
        }
    }

    func testAPIKeyShrinkAndExpand() {
        guard let username = username,
            let apiKey = apiKey else {
                XCTFail()
                return
        }

        let expectation = self.expectation(description: "Bitly")
        let url = URL(string: "https://encrypted.google.com/search?hl=en&q=bitly")

        _ = BitlyClient.shorten(url: url, username: username, apiKey: apiKey) { (shortenedURL, error) in
            XCTAssertNotNil(shortenedURL)
            XCTAssertNil(error)
            _ = BitlyClient.expand(url: shortenedURL, username: self.username, apiKey: self.apiKey, completionHandler: { (expandedURL, error) in
                XCTAssertNotNil(expandedURL)
                XCTAssertNil(error)
                expectation.fulfill()
            })
        }

        let timeout: TimeInterval = 5.0
        waitForExpectations(timeout: timeout) { (error) in
            if let error = error {
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
    }

    func testAccessTokenShrinkAndExpand() {
        guard let accessToken = accessToken else {
                XCTFail()
                return
        }

        let expectation = self.expectation(description: "Bitly")
        let url = URL(string: "https://encrypted.google.com/search?hl=en&q=bitly")

        _ = BitlyClient.shorten(url: url, accessToken: accessToken) { (shortenedURL, error) in
            XCTAssertNotNil(shortenedURL)
            XCTAssertNil(error)
            _ = BitlyClient.expand(url: shortenedURL, accessToken: self.accessToken, completionHandler: { (expandedURL, error) in
                XCTAssertNotNil(expandedURL)
                XCTAssertNil(error)
                expectation.fulfill()
            })
        }

        let timeout: TimeInterval = 5.0
        waitForExpectations(timeout: timeout) { (error) in
            if let error = error {
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
    }

}
