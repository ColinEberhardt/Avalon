//
//  TestUtils.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 03/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import Avalon
import XCTest

// executes the given function, asserting that a log message containin
// the given text is recorded
func AssertLogsError(message: String, fn: ()->()) {
  
  // add a logging sink
  var error: String = ""
  func errorReporter(event: String) {
    error = event
  }
  ErrorSink.instance.setSink(errorReporter)
  
  // perform the test
  fn()
  
  // verify an error was logged
  let range = error.rangeOfString(message)
  XCTAssertTrue(range != nil, "The reported message {\(error)} did not contain the expected text {\(message)}")
}