//
//  LogicValueTransformersTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 08/01/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import Foundation
import XCTest
import Avalon

class LogicValueTransformerTest: XCTestCase {
  
  class ViewModel: NSObject {
    dynamic var booleanValue: Bool = true
    
    override init() {
      super.init()
    }
  }
  
  func test_notValueTransformer() {
    let swtch = UISwitch()
    swtch.bindings = ["booleanValue" >>| "Not" >>| "on"]
    
    let viewModel = ViewModel()
    swtch.bindingContext = viewModel
    XCTAssertEqual(swtch.on, !viewModel.booleanValue)
    
    viewModel.booleanValue = !viewModel.booleanValue
    XCTAssertEqual(swtch.on, !viewModel.booleanValue)
  }
  
  func test_nonBooleanValue_logsError() {
    AssertLogsError("ERROR:") {
      let label = UILabel()
      label.bindings = ["." >>| "Not" >>| "hidden"]
      label.bindingContext = NSDate()
      XCTAssertFalse(label.hidden)
    }
  }
}