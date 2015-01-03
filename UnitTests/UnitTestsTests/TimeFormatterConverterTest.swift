//
//  TimeFormatterConverterTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 30/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class TimeFormatterConverterTest: XCTestCase {
  
  func createBoundLabel(transformer: NSValueTransformer) -> UILabel {
    let label = UILabel()
    label.bindings = [Binding(source: ".", destination: "text", transformer: transformer)]
    
    // add a view model
    let viewModel = NSDate(timeIntervalSince1970:0.0)
    label.bindingContext = viewModel
    return label
  }
  
  func test_shortStyle() {
    let label = createBoundLabel(TimeFormatterConverterShortStyle())
    XCTAssertEqual(label.text!, "1:00 AM")
  }
  
  func test_mediumStyle() {
    let label = createBoundLabel(TimeFormatterConverterMediumStyle())
    XCTAssertEqual(label.text!, "1:00:00 AM")
  }
  
  func test_longStyle() {
    let label = createBoundLabel(TimeFormatterConverterLongStyle())
    XCTAssertEqual(label.text!, "1:00:00 AM GMT+1")
  }
  
  func test_fullStyle() {
    let label = createBoundLabel(TimeFormatterConverterFullStyle())
    XCTAssertEqual(label.text!, "1:00:00 AM GMT+01:00")
  }
}
