//
//  NumberValueTransformerTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 30/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class NumberValueTransformerTest: XCTestCase {
  
  func createBoundLabel(transformer: NSValueTransformer, _ number: Float = 12.345678) -> UILabel {
    let label = UILabel()
    label.bindings = [Binding(source: ".", destination: "text", transformer: transformer)]
    
    // add a view model
    let viewModel = number
    label.bindingContext = viewModel
    return label
  }
  
  func createBoundLabel(transformer: String, _ number: Float = 12.345678) -> UILabel {
    let label = UILabel()
    label.bindings = [
      "." >>| transformer >>| "text"
    ]
    
    // add a view model
    let viewModel = number
    label.bindingContext = viewModel
    return label
  }
  
  func test_decimalStyle() {
    let label = createBoundLabel(NumberValueTransformerDecimalStyle())
    XCTAssertEqual(label.text!, "12.346")
    
    let label2 = createBoundLabel("DecimalStyle")
    XCTAssertEqual(label2.text!, "12.346")
  }
  
  func test_currencyStyle() {
    let label = createBoundLabel(NumberValueTransformerCurrencyStyle())
    XCTAssertEqual(label.text!, "$12.35")
    
    let label2 = createBoundLabel("CurrencyStyle")
    XCTAssertEqual(label2.text!, "$12.35")
  }
  
  func test_percentStyle() {
    let label = createBoundLabel(NumberValueTransformerPercentStyle(), 0.76)
    XCTAssertEqual(label.text!, "76%")
    
    let label2 = createBoundLabel("PercentStyle", 0.76)
    XCTAssertEqual(label2.text!, "76%")
  }
  
  func test_scientificStyle() {
    let label = createBoundLabel(NumberValueTransformerScientificStyle(), 12)
    XCTAssertEqual(label.text!, "1.2E1")
    
    let label2 = createBoundLabel("ScientificStyle", 12)
    XCTAssertEqual(label2.text!, "1.2E1")
  }
  
  func test_intStyle() {
    let label = createBoundLabel(NumberValueTransformerIntStyle(), 12.56)
    XCTAssertEqual(label.text!, "13")
    
    let label2 = createBoundLabel("IntStyle", 12)
    XCTAssertEqual(label2.text!, "12")
    
    let label3 = createBoundLabel(NumberValueTransformerIntStyle(), 123456)
    XCTAssertEqual(label3.text!, "123,456")
  }
  
  func test_nonNumericValue_logsError() {
    AssertLogsError("ERROR:") {
      let label = UILabel()
      label.bindings = ["." >>| "IntStyle" >>| "text"]
      
      // add a view model
      let viewModel = NSDate()
      label.bindingContext = viewModel
      
      XCTAssertNil(label.text)
    }
  }
  
  func test_acceptsIntValues() {
    let label = UILabel()
    label.bindings = ["." >>| "DecimalStyle" >>| "text"]
    label.bindingContext = Int(23)
    XCTAssertEqual(label.text!, "23")
  }
  
  func test_acceptsDoubleValues() {
    let label = UILabel()
    label.bindings = ["." >>| "DecimalStyle" >>| "text"]
    label.bindingContext = Double(23.456789)
    XCTAssertEqual(label.text!, "23.457")
  }
}
