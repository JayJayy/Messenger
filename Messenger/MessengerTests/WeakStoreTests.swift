//
//  WeakStoreTests.swift
//  Budget
//
//  Created by Johannes Starke on 28.10.16.
//  Copyright © 2016 Johannes Starke. All rights reserved.
//

import XCTest
@testable import Messenger

struct WeakObject: WeakStoreable {
    weak var object: AnyObject?
    
    var canRemove: Bool {
        return object == nil
    }
}

class WeakStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAdd() {
        let sut = WeakStore<WeakObject>()
        let object = NSObject()
        
        sut.store(item: WeakObject(object: object), in: "TestStore")
        
        XCTAssertEqual(sut.items(from: "TestStore").count, 1)
    }
    
    func testStores() {
        let sut = WeakStore<WeakObject>()
        
        let store1 = "Store1"
        let store1Samples = [NSObject](repeating: NSObject(), count: 3)
        let store2 = "Store2"
        let store2Samples = [NSObject](repeating: NSObject(), count: 5)
        
        for sample in store1Samples {
            sut.store(item: WeakObject(object: sample), in: store1)
        }
        
        for sample in store2Samples {
            sut.store(item: WeakObject(object: sample), in: store2)
        }
        
        XCTAssertEqual(sut.items(from: store1).count, 3)
        XCTAssertEqual(sut.items(from: store1).map({ $0.object as! NSObject }), store1Samples)
        XCTAssertEqual(sut.items(from: store2).count, 5)
        XCTAssertEqual(sut.items(from: store2).map({ $0.object as! NSObject }), store2Samples)
    }
    
    func testItems() {
        let sut = WeakStore<WeakObject>()
        
        let samples = [NSString(format: "abc"), NSString(format: "def")]
        
        for sample in samples {
            sut.store(item: WeakObject(object: sample), in: "TestStore")
        }
        
        for item in sut.items(from: "TestStore") {
            XCTAssert(samples.contains(item.object as! NSString))
        }
    }
    
    func testWeakness() {
        let sut = WeakStore<WeakObject>()
        weak var weakTestObject: AnyObject? = nil
        
        let testBlock = {
            let object = NSObject()
            weakTestObject = object
            
            sut.store(item: WeakObject(object: object), in: "TestStore")
            
            XCTAssertNotNil(weakTestObject)
        }
        
        testBlock()
        
        // Just wait
        let asyncExpectation = expectation(description: "justWait")
        
        DispatchQueue(label: "justWaitQueue").async {
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { _ in
            XCTAssertNil(weakTestObject)
            XCTAssert(sut.items(from: "TestStore").count == 0)
        }
    }
    
    func testThreading() {
        let sut = WeakStore<WeakObject>()
        
        let strongStore1 = [NSObject](repeating: NSObject(), count: 1000)
        let strongStore2 = [NSObject](repeating: NSObject(), count: 1000)
        
        let asyncExpectation = expectation(description: "storeWrite")
        
        DispatchQueue(label: "writeSet1Queue").async {
            for item in strongStore1 {
                sut.store(item: WeakObject(object: item), in: "TestStore")
            }
        }
        
        DispatchQueue(label: "writeSet2Queue").async {
            for item in strongStore2 {
                sut.store(item: WeakObject(object: item), in: "TestStore")
            }
        }
        
        DispatchQueue(label: "waitForResultQueue").async {
            while sut.items(from: "TestStore").count < 2000 {
                usleep(500)
            }
            
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error)
            XCTAssertEqual(2000, sut.items(from: "TestStore").count)
        }
    }
}
