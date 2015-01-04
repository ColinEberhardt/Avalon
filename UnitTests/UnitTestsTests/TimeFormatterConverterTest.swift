//
//  TimeValueTransformerTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 30/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class TimeValueTransformerTest: XCTestCase {
  
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
    let label = createBoundLabel(TimeValueTransformerShortStyle())
    XCTAssertEqual(label.text!, "1:00 AM")
    
    let label2 = createBoundLabel("TimeShortStyle")
    XCTAssertEqual(label2.text!, "1:00 AM")
  }
  
  func test_mediumStyle() {
    let label = createBoundLabel(TimeValueTransformerMediumStyle())
    XCTAssertEqual(label.text!, "1:00:00 AM")
    
    let label2 = createBoundLabel("TimeMediumStyle")
    XCTAssertEqual(label2.text!, "1:00:00 AM")
  }
  
  func test_longStyle() {
    let label = createBoundLabel(TimeValueTransformerLongStyle())
    XCTAssertEqual(label.text!, "1:00:00 AM GMT+1")
    
    let label2 = createBoundLabel("TimeLongStyle")
    XCTAssertEqual(label2.text!, "1:00:00 AM GMT+1")
  }
  
  func test_fullStyle() {
    let label = createBoundLabel(TimeValueTransformerFullStyle())
    XCTAssertEqual(label.text!, "1:00:00 AM GMT+01:00")
    
    let label2 = createBoundLabel("TimeFullStyle")
    XCTAssertEqual(label2.text!, "1:00:00 AM GMT+01:00")
  }
}
