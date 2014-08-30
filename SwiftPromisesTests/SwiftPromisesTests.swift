//
//  SwiftPromisesTests.swift
//  SwiftPromisesTests
//
//  Created by Josh Holtz on 8/25/14.
//  Copyright (c) 2014 RokkinCat. All rights reserved.
//

import UIKit
import XCTest

class SwiftPromisesTests: XCTestCase {
    
    func testResolve() {
        var expectationThen = expectationWithDescription("promise.then")
        var expectationFinally = expectationWithDescription("promise.finally")
        
        let promise = Promise { (resolve, reject) -> () in resolve("Yay") }
            .then { (value) -> () in
                expectationThen.fulfill()
                XCTAssertEqual("Yay", value as String, "Value should equal")
            }
            promise.finally { () -> () in // Using promise.finally because we need to access its status
                expectationFinally.fulfill()
                XCTAssertEqual(Status.RESOLVED, promise.status, "Value should equal")
            }
        
        waitForExpectationsWithTimeout(0, nil)
    }
    
    func testReject() {
        var expectationCatch = expectationWithDescription("promise.catch")
        var expectationFinally = expectationWithDescription("promise.finally")
        
        let promise = Promise { (resolve, reject) -> () in reject("Nay") }
            .catch { (value) -> () in
                expectationCatch.fulfill()
                XCTAssertEqual("Nay", value as String, "Value should equal")
            }
            promise.finally { () -> () in // Using promise.finally because we need to access its status
                expectationFinally.fulfill()
                XCTAssertEqual(Status.REJECTED, promise.status, "Value should equal")
            }
        
        waitForExpectationsWithTimeout(0, nil)
    }
    
    func testMultipleThens() {
        var expectationThen1 = expectationWithDescription("promise.then 1")
        var expectationThen2 = expectationWithDescription("promise.then 2")
        var expectationThen3 = expectationWithDescription("promise.then 3")
        
        let promise = Promise { (resolve, reject) -> () in resolve("Yay") }
            .then { (value) -> () in
                expectationThen1.fulfill()
                XCTAssertEqual("Yay", value as String, "Value should equal")
            }
            .then { (value) -> () in
                expectationThen2.fulfill()
                XCTAssertEqual("Yay", value as String, "Value should equal")
            }
            .then { (value) -> () in
                expectationThen3.fulfill()
                XCTAssertEqual("Yay", value as String, "Value should equal")
            }
        
        waitForExpectationsWithTimeout(0, nil)
    }
    
    func testMultipleThensWithReturns() {
        var expectationThen1 = expectationWithDescription("promise.then 1")
        var expectationThen2 = expectationWithDescription("promise.then 2")
        var expectationThen3 = expectationWithDescription("promise.then 3")
        var expectationFinally = expectationWithDescription("promise.finally")
        
        let promise = Promise { (resolve, reject) -> () in resolve("Yay") }
            .then { (value) -> (AnyObject?) in
                expectationThen1.fulfill()
                XCTAssertEqual("Yay", value as String, "Value should equal")
                return "Yay 2"
            }
            .then { (value) -> (AnyObject?) in
                expectationThen2.fulfill()
                XCTAssertEqual("Yay 2", value as String, "Value should equal")
                return "Yay 3"
            }
            .then { (value) -> (AnyObject?) in
                expectationThen3.fulfill()
                XCTAssertEqual("Yay 3", value as String, "Value should equal")
                return "Yay 4"
            }
            promise.finally { () -> () in // Using promise.finally because we need to access its status
                expectationFinally.fulfill()
                XCTAssertEqual(Status.RESOLVED, promise.status, "Value should equal")
                XCTAssertEqual("Yay 4", promise.value as String, "Value should equal")
            }
        
        waitForExpectationsWithTimeout(0, nil)
    }
    
}
