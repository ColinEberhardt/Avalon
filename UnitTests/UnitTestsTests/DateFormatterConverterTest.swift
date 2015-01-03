//
//  DateFormatterConverterTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 30/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class DateFormatterConverterTest: XCTestCase {
  
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
    let label = createBoundLabel(DateFormatterConverterShortStyle())
    XCTAssertEqual(label.text!, "1/1/70")
    
    let label2 = createBoundLabel("AVDateConverterShortStyle")
    XCTAssertEqual(label2.text!, "1/1/70")
  }
  
  func test_mediumStyle() {
    let label = createBoundLabel(DateFormatterConverterMediumStyle())
    XCTAssertEqual(label.text!, "Jan 1, 1970")
    
    let label2 = createBoundLabel("AVDateConverterMediumStyle")
    XCTAssertEqual(label2.text!, "Jan 1, 1970")
  }
  
  func test_longStyle() {
    let label = createBoundLabel(DateFormatterConverterLongStyle())
    XCTAssertEqual(label.text!, "January 1, 1970")
    
    let label2 = createBoundLabel("AVDateConverterLongStyle")
    XCTAssertEqual(label2.text!, "January 1, 1970")
  }
  
  func test_fullStyle() {
    let label = createBoundLabel(DateFormatterConverterFullStyle())
    XCTAssertEqual(label.text!, "Thursday, January 1, 1970")
    
    let label2 = createBoundLabel("AVDateConverterFullStyle")
    XCTAssertEqual(label2.text!, "Thursday, January 1, 1970")
  }
}
