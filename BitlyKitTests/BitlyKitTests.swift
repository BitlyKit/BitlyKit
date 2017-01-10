//
//  BitlyKitTests.swift
//  BitlyKitTests
//
//  Created by Brennan Stehling on 1/7/17.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import XCTest
@testable import BitlyKit

class BitlyKitTests: XCTestCase {

    let fakeLongURL = URL(string: "http://www.apple.com/car")!
    let fakeShortURL = URL(string: "http://bit.ly/ab123")!
    let fakeAccessToken = "abc123xyz789"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

        BitlyTestClient.json = nil
        BitlyTestClient.error = nil
    }

    func testLoadingJSON() {
        guard let shortenGoodJSON = JSONLoader.sharedInstance.loadJSON(name: "shorten-good"),
            let expandGoodJSON = JSONLoader.sharedInstance.loadJSON(name: "expand-good") else {
                XCTFail()
                return
        }

        guard let shortenGoodDictionary = shortenGoodJSON as? [AnyHashable:Any],
            let expandGoodDictionary = expandGoodJSON as? [AnyHashable:Any] else {
                XCTFail()
                return
        }

        guard let shortenStatusCode = shortenGoodDictionary[BitlyStatusCodeKey] as? Int,
        let expandStatusCode = expandGoodDictionary[BitlyStatusCodeKey] as? Int,
        let shortenStatusText = shortenGoodDictionary[BitlyStatusTextKey] as? String,
            let expandStatusText = expandGoodDictionary[BitlyStatusTextKey] as? String else {
                XCTFail()
                return
        }

        XCTAssertEqual(shortenStatusCode, 200)
        XCTAssertEqual(expandStatusCode, 200)
        XCTAssertEqual(shortenStatusText, BitlyStatusOK)
        XCTAssertEqual(expandStatusText, BitlyStatusOK)
    }

    // MARK: - Shorten Tests -

    func testShortenGoodJSON() {
        guard let json = JSONLoader.sharedInstance.loadJSON(name: "shorten-good") else {
            XCTFail()
            return
        }

        let expectation = self.expectation(description: "Bitly")
        BitlyTestClient.json = json
        _ = BitlyTestClient.shorten(url: fakeLongURL, accessToken: fakeAccessToken) { (url, error) in
            XCTAssertNotNil(url)
            XCTAssertNil(error)

            guard let url = url else {
                XCTFail()
                expectation.fulfill()
                return
            }

            XCTAssertEqual(url.absoluteString, "http://sstools.co/2iWad1L")

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testShortenMissingAccessTokenJSON() {
        guard let json = JSONLoader.sharedInstance.loadJSON(name: "shorten-missing-access-token") else {
            XCTFail()
            return
        }

        let expectation = self.expectation(description: "Bitly")
        BitlyTestClient.json = json
        _ = BitlyTestClient.shorten(url: fakeLongURL, accessToken: fakeAccessToken) { (url, error) in
            XCTAssertNil(url)
            XCTAssertNotNil(error)
            let errorType = BitlyError.errorType(error: error)
            XCTAssertEqual(errorType, .apiError)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testShortenMissingArgumentsJSON() {
        guard let json = JSONLoader.sharedInstance.loadJSON(name: "shorten-missing-args") else {
            XCTFail()
            return
        }

        let expectation = self.expectation(description: "Bitly")
        BitlyTestClient.json = json
        _ = BitlyTestClient.shorten(url: fakeLongURL, accessToken: fakeAccessToken) { (url, error) in
            XCTAssertNil(url)
            XCTAssertNotNil(error)
            let errorType = BitlyError.errorType(error: error)
            XCTAssertEqual(errorType, .apiError)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testShortenBadJSON() {
        guard let json = JSONLoader.sharedInstance.loadJSON(name: "shorten-bad") else {
            XCTFail()
            return
        }

        let expectation = self.expectation(description: "Bitly")
        BitlyTestClient.json = json
        _ = BitlyTestClient.shorten(url: fakeLongURL, accessToken: fakeAccessToken) { (url, error) in
            XCTAssertNil(url)
            XCTAssertNotNil(error)
            let errorType = BitlyError.errorType(error: error)
            XCTAssertEqual(errorType, .unexpectedResponse)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testShortenWithIncompleteAccessTokenParameters() {
        let expectation = self.expectation(description: "Bitly")
        _ = BitlyClient.shorten(url: nil, accessToken: nil) { (url, error) in
            XCTAssertNil(url)
            XCTAssertNotNil(error)
            let errorType = BitlyError.errorType(error: error)
            XCTAssertEqual(errorType, .incompleteParameters)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testShortenWithIncompleteUsernameAndApiKeyParameters() {
        let expectation = self.expectation(description: "Bitly")
        _ = BitlyClient.shorten(url: nil, username: nil, apiKey: nil) { (url, error) in
            XCTAssertNil(url)
            XCTAssertNotNil(error)
            let errorType = BitlyError.errorType(error: error)
            XCTAssertEqual(errorType, .incompleteParameters)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testShorteningReturningError() {
        let expectation = self.expectation(description: "Bitly")

        BitlyTestClient.error = BitlyTestClient.prepareError(bitlyError: .failureToShortenURL)
        _ = BitlyTestClient.shorten(url: fakeLongURL, accessToken: fakeAccessToken) { (url, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(url)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testShorteningWithoutCompletionHandler() {
        let task = BitlyClient.shorten(url: fakeLongURL, accessToken: fakeAccessToken, completionHandler: nil)
        XCTAssertNil(task)
    }

    // MARK: - Expand Tests -

    func testExpandGoodJSON() {
        guard let json = JSONLoader.sharedInstance.loadJSON(name: "expand-good") else {
            XCTFail()
            return
        }

        let expectation = self.expectation(description: "Bitly")
        BitlyTestClient.json = json
        _ = BitlyTestClient.expand(url: fakeShortURL, accessToken: fakeAccessToken) { (url, error) in
            XCTAssertNotNil(url)
            XCTAssertNil(error)

            guard let url = url else {
                XCTFail()
                expectation.fulfill()
                return
            }

            XCTAssertEqual(url.absoluteString, "https://en.wikipedia.org/wiki/Richard_Feynman")

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testExpandMissingAccessTokenJSON() {
        guard let json = JSONLoader.sharedInstance.loadJSON(name: "expand-missing-access-token") else {
            XCTFail()
            return
        }

        let expectation = self.expectation(description: "Bitly")
        BitlyTestClient.json = json
        _ = BitlyTestClient.expand(url: fakeShortURL, accessToken: fakeAccessToken) { (url, error) in
            XCTAssertNil(url)
            XCTAssertNotNil(error)
            let errorType = BitlyError.errorType(error: error)
            XCTAssertEqual(errorType, .apiError)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testExpandMissingArgumentsJSON() {
        guard let json = JSONLoader.sharedInstance.loadJSON(name: "expand-missing-args") else {
            XCTFail()
            return
        }

        let expectation = self.expectation(description: "Bitly")
        BitlyTestClient.json = json
        _ = BitlyTestClient.expand(url: fakeShortURL, accessToken: fakeAccessToken) { (url, error) in
            XCTAssertNil(url)
            XCTAssertNotNil(error)
            let errorType = BitlyError.errorType(error: error)
            XCTAssertEqual(errorType, .apiError)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testExpandBadJSON() {
        guard let json = JSONLoader.sharedInstance.loadJSON(name: "expand-bad") else {
            XCTFail()
            return
        }

        let expectation = self.expectation(description: "Bitly")
        BitlyTestClient.json = json
        _ = BitlyTestClient.expand(url: fakeShortURL, accessToken: fakeAccessToken) { (url, error) in
            XCTAssertNil(url)
            XCTAssertNotNil(error)
            let errorType = BitlyError.errorType(error: error)
            XCTAssertEqual(errorType, .unexpectedResponse)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testExpandWithIncompleteAccessTokenParameters() {
        let expectation = self.expectation(description: "Bitly")
        _ = BitlyClient.expand(url: nil, accessToken: nil) { (url, error) in
            XCTAssertNil(url)
            XCTAssertNotNil(error)
            let errorType = BitlyError.errorType(error: error)
            XCTAssertEqual(errorType, .incompleteParameters)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testExpandWithIncompleteUsernameAndApiKeyParameters() {
        let expectation = self.expectation(description: "Bitly")
        _ = BitlyClient.expand(url: nil, username: nil, apiKey: nil) { (url, error) in
            XCTAssertNil(url)
            XCTAssertNotNil(error)
            let errorType = BitlyError.errorType(error: error)
            XCTAssertEqual(errorType, .incompleteParameters)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testExpandingReturningError() {
        let expectation = self.expectation(description: "Bitly")

        BitlyTestClient.error = BitlyTestClient.prepareError(bitlyError: .failureToExpandURL)
        _ = BitlyTestClient.shorten(url: fakeLongURL, accessToken: fakeAccessToken) { (url, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(url)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testExpandingWithoutCompletionHandler() {
        let task = BitlyClient.expand(url: fakeShortURL, accessToken: fakeAccessToken, completionHandler: nil)
        XCTAssertNil(task)
    }

}
