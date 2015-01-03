//
//  NumberFormatterConverterTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 30/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class NumberFormatterConverterTest: XCTestCase {
  
  func test_decimalStyle() {
    // create a bound label
    let label = UILabel()
    label.bindings = [Binding(source: ".", destination: "text", transformer: NumberFormatterConverterDecimalStyle())]
    
    // add a view model
    let viewModel = Float(12.345678)
    label.bindingContext = viewModel
    
    // state
    XCTAssertEqual(label.text!, "12.346")
  }
  
  func test_currencyStyle() {
    // create a bound label
    let label = UILabel()
    label.bindings = [Binding(source: ".", destination: "text", transformer: NumberFormatterConverterCurrencyStyle())]
    
    // add a view model
    let viewModel = Float(12.345678)
    label.bindingContext = viewModel
    
    // state
    XCTAssertEqual(label.text!, "$12.35")
  }
  
  func test_percentStyle() {
    // create a bound label
    let label = UILabel()
    label.bindings = [Binding(source: ".", destination: "text", transformer: NumberFormatterConverterPercentStyle())]
    
    // add a view model
    let viewModel = Float(0.76)
    label.bindingContext = viewModel
    
    // state
    XCTAssertEqual(label.text!, "76%")
  }
  
  func test_scientificStyle() {
    // create a bound label
    let label = UILabel()
    label.bindings = [Binding(source: ".", destination: "text", transformer: NumberFormatterConverterScientificStyle())]
    
    // add a view model
    let viewModel = Float(12)
    label.bindingContext = viewModel
    
    // state
    XCTAssertEqual(label.text!, "1.2E1")
  }
}
