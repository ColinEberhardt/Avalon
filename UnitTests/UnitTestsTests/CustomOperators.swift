//
//  CustomOperators.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 03/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class CustomOperatorTest: XCTestCase {
  

  func test_oneWayBinding() {
    
    let binding = "foo" >| "bar"
    
    XCTAssertEqual("foo", binding.sourceProperty)
    XCTAssertEqual("bar", binding.destinationProperty)
    XCTAssertNil(binding.converter)
    XCTAssertEqual(BindingMode.OneWay, binding.mode)
  }
  
  func test_oneWayBinding_withConverter() {
    
    let converter = ValueConverter()
    let binding = "foo" >| converter >| "bar"
    
    XCTAssertEqual("foo", binding.sourceProperty)
    XCTAssertEqual("bar", binding.destinationProperty)
    XCTAssertEqual(converter, binding.converter!)
  }
  
  func test_twoWayBinding() {
    let binding = "foo" |<>| "bar"
    
    XCTAssertEqual("foo", binding.sourceProperty)
    XCTAssertEqual("bar", binding.destinationProperty)
    XCTAssertNil(binding.converter)
    XCTAssertEqual(BindingMode.TwoWay, binding.mode)
  }
}
