//
//  MessengerTests.swift
//  Budget
//
//  Created by Johannes Starke on 29.10.16.
//  Copyright © 2016 Johannes Starke. All rights reserved.
//

import XCTest
@testable import Messenger

struct TestMessage: Message {
    let test: Int
}

class MessengerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMessengerWithSelfAsObserver() {
        let sut = Messenger()

        let test = 10
        
        let messageExpectation = expectation(description: "waitingForMessage")
        
        sut.subscripte(me: self, to: TestMessage.self) { message in
            XCTAssertEqual(message.test, test)
            
            messageExpectation.fulfill()
        }
        
        DispatchQueue(label: "MessagePublish").async {
            sut.publish(message: TestMessage(test: test))
        }
        
        waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testMessengerWithTokenAsObserver() {
        let sut = Messenger()

        var token: AnyObject? = NSObject()
        var callCount: Int = 0

        let messageExpectation = expectation(description: "waitingForMessages")

        if let token = token {
            sut.subscripte(me: token, to: TestMessage.self) { _ in
                callCount += 1
            }
        }

        DispatchQueue(label: "MessagePublish").async {
            sut.publish(message: TestMessage(test: 0))

            XCTAssertEqual(callCount, 1)

            token = nil
            
            sut.publish(message: TestMessage(test: 0))

            XCTAssertEqual(callCount, 1)

            messageExpectation.fulfill()
        }

        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error)
        }
    }
    
}
