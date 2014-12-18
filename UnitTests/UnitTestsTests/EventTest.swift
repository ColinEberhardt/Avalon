//
//  EventTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 08/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class EventTest: XCTestCase {
  
  var handlerOneInvoked = false, handlerTwoInvoked = false
  
  var stringOne = "", stringTwo = ""
  
  override func setUp() {
    reset()
  }
  
  func reset() {
    handlerOneInvoked = false
    handlerTwoInvoked = false
    stringOne = ""
    stringTwo = ""
  }
  
  func handlerOne() {
    handlerOneInvoked = true
  }
  func handlerTwo() {
    handlerTwoInvoked = true
  }
  
  func dataHandlerOne(data: String) {
    stringOne = data
  }
  func dataHandlerTwo(data: String) {
    stringTwo = data
  }

  
  func test_event_addHandler() {
    // add a single handler
    let event = Event()
    event.addHandler(self, handler: EventTest.handlerOne)
    
    // raise
    event.raiseEvent()
    
    // assert
    XCTAssertTrue(handlerOneInvoked)
    XCTAssertFalse(handlerTwoInvoked)
    
    // add the other handler, using operator
    reset()
    event.addHandler(self, handler: EventTest.handlerTwo)
    
    // raise
    event.raiseEvent()
    
    // assert
    XCTAssertTrue(handlerOneInvoked)
    XCTAssertTrue(handlerTwoInvoked)
  }
  
  func test_event_removeHandler() {
    // add both handlers
    let event = Event()
    let handleOne = event.addHandler(self, handler: EventTest.handlerOne)
    let handlerTwo = event.addHandler(self, handler: EventTest.handlerTwo)
    
    // raise
    event.raiseEvent()
    
    // assert
    XCTAssertTrue(handlerOneInvoked)
    XCTAssertTrue(handlerTwoInvoked)
    
    // remove one
    handleOne.dispose()
    
    // raise
    reset()
    event.raiseEvent()
    
    // assert
    XCTAssertFalse(handlerOneInvoked)
    XCTAssertTrue(handlerTwoInvoked)
    
    // remove the other
    handlerTwo.dispose()
    
    // raise
    reset()
    event.raiseEvent()
    
    // assert
    XCTAssertFalse(handlerOneInvoked)
    XCTAssertFalse(handlerTwoInvoked)
  }
  
  func test_dataEvent_removeHandler() {
    // add both handlers
    let event = DataEvent<String>()
    let handleOne = event.addHandler(self, handler: EventTest.dataHandlerOne)
    let handlerTwo = event.addHandler(self, handler: EventTest.dataHandlerTwo)
    
    // raise
    event.raiseEvent("fish")
    
    // assert
    XCTAssertEqual("fish", stringOne)
    XCTAssertEqual("fish", stringTwo)

    
    // remove one
    handleOne.dispose()
    
    // raise
    reset()
    event.raiseEvent("cat")
    
    // assert
    XCTAssertEqual("", stringOne)
    XCTAssertEqual("cat", stringTwo)
    
    // remove the other
    handlerTwo.dispose()
    
    // raise
    reset()
    event.raiseEvent("dog")
    
    // assert
    XCTAssertEqual("", stringOne)
    XCTAssertEqual("", stringTwo)
  }
  
  
  func test_dataEvent_addHandler() {
    // add a single handler
    let event = DataEvent<String>()
    event.addHandler(self, handler: EventTest.dataHandlerOne)
    
    // raise
    event.raiseEvent("fish")
    
    // assert
    XCTAssertEqual("fish", stringOne)
    XCTAssertEqual("", stringTwo)
    
    // add the other handler, using operator
    reset()
    event.addHandler(self, handler: EventTest.dataHandlerTwo)
    
    // raise
    event.raiseEvent("fish")
    
    // assert
    XCTAssertEqual("fish", stringOne)
    XCTAssertEqual("fish", stringTwo)
  }
  
}