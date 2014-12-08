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
    event.addHandler(handlerOne)
    
    // raise
    event.raiseEvent()
    
    // assert
    XCTAssertTrue(handlerOneInvoked)
    XCTAssertFalse(handlerTwoInvoked)
    
    // add the other handler, using operator
    reset()
    event += handlerTwo
    
    // raise
    event.raiseEvent()
    
    // assert
    XCTAssertTrue(handlerOneInvoked)
    XCTAssertTrue(handlerTwoInvoked)
  }
  
  func test_dataEvent_addHandler() {
    // add a single handler
    let event = DataEvent<String>()
    event.addHandler(dataHandlerOne)
    
    // raise
    event.raiseEvent("fish")
    
    // assert
    XCTAssertEqual("fish", stringOne)
    XCTAssertEqual("", stringTwo)
    
    // add the other handler, using operator
    reset()
    event += dataHandlerTwo
    
    // raise
    event.raiseEvent("fish")
    
    // assert
    XCTAssertEqual("fish", stringOne)
    XCTAssertEqual("fish", stringTwo)
  }
  
}