//
//  UIButtonTests.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 06/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

import UIKit
import XCTest
import Avalon

class Custom2OperatorTest: XCTestCase {

  func test_actionOblyInvokedOnce() {
    
    var invocations = 0
    let actionOne = ClosureAction {
      println("foo")
    }
    
    let actionTwo = ClosureAction {
      invocations = invocations + 1
    }
    
    let button = UIButton()
    button.action = actionOne
    button.action = actionTwo
    
    button.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    
    XCTAssertEqual(1, invocations)
  }
}