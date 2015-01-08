//
//  DateValueTransformerTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 30/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class DateValueTransformerTest: XCTestCase {
  
  func createBoundLabel(transformer: NSValueTransformer) -> UILabel {
    let label = UILabel()
    label.bindings = [Binding(source: ".", destination: "text", transformer: transformer)]
    
    // add a view model
    let viewModel = NSDate(timeIntervalSince1970:0.0)
    label.bindingContext = viewModel
    return label
  }
  
  func createBoundLabel(transformer: String) -> UILabel {
    let label = UILabel()
    label.bindings = [
      "." >>| transformer >>| "text"
    ]
    
    // add a view model
    let viewModel = NSDate(timeIntervalSince1970:0.0)
    label.bindingContext = viewModel
    return label
  }
  
  func test_shortStyle() {
    let label = createBoundLabel(DateValueTransformerShortStyle())
    XCTAssertEqual(label.text!, "1/1/70")
    
    let label2 = createBoundLabel("DateShortStyle")
    XCTAssertEqual(label2.text!, "1/1/70")
  }
  
  func test_mediumStyle() {
    let label = createBoundLabel(DateValueTransformerMediumStyle())
    XCTAssertEqual(label.text!, "Jan 1, 1970")
    
    let label2 = createBoundLabel("DateMediumStyle")
    XCTAssertEqual(label2.text!, "Jan 1, 1970")
  }
  
  func test_longStyle() {
    let label = createBoundLabel(DateValueTransformerLongStyle())
    XCTAssertEqual(label.text!, "January 1, 1970")
    
    let label2 = createBoundLabel("DateLongStyle")
    XCTAssertEqual(label2.text!, "January 1, 1970")
  }
  
  func test_fullStyle() {
    let label = createBoundLabel(DateValueTransformerFullStyle())
    XCTAssertEqual(label.text!, "Thursday, January 1, 1970")
    
    let label2 = createBoundLabel("DateFullStyle")
    XCTAssertEqual(label2.text!, "Thursday, January 1, 1970")
  }
  
  func test_nonDateValue_logsError() {
    AssertLogsError("ERROR:") {
      let label = UILabel()
      label.bindings = ["." >>| "DateFullStyle" >>| "text"]
      
      // add a view model
      let viewModel = "foo"
      label.bindingContext = viewModel
      
      XCTAssertNil(label.text)
    }
  }
}
