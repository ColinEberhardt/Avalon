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

class DummyTransformer: NSValueTransformer {
  override class func load() {
    NSValueTransformer.setValueTransformer(DummyTransformer(), forName: "DummyTransformer")
  }
}

class CustomOperatorTest: XCTestCase {
  
  func test_oneWayBinding() {
    
    let binding = "foo" >| "bar"
    
    XCTAssertEqual("foo", binding.sourceProperty)
    XCTAssertEqual("bar", binding.destinationProperty)
    XCTAssertNil(binding.transformer)
    XCTAssertEqual(BindingMode.OneWay, binding.mode)
  }
  
  func test_oneWayBinding_withConverter() {
    
    let binding = "foo" >>| "DummyTransformer" >>| "bar"
    
    XCTAssertEqual("foo", binding.sourceProperty)
    XCTAssertEqual("bar", binding.destinationProperty)
    XCTAssertTrue(binding.transformer!.dynamicType === DummyTransformer.self)
  }
  
  func test_twoWayBinding() {
    let binding = "foo" |<>| "bar"
    
    XCTAssertEqual("foo", binding.sourceProperty)
    XCTAssertEqual("bar", binding.destinationProperty)
    XCTAssertNil(binding.transformer)
    XCTAssertEqual(BindingMode.TwoWay, binding.mode)
  }
  
  func test_twoWayBinding_withConverter() {
    
    let binding = "foo" |<< "DummyTransformer" >>| "bar"
    
    XCTAssertEqual("foo", binding.sourceProperty)
    XCTAssertEqual("bar", binding.destinationProperty)
    XCTAssertTrue(binding.transformer!.dynamicType === DummyTransformer.self)
    XCTAssertEqual(BindingMode.TwoWay, binding.mode)
  }
  
  func test_twoWayBinding_withUnknownConverter() {
    AssertLogsError("ERROR: The transformer floob was not found") {
      let binding = "foo" |<< "floob" >>| "bar"
    }
  }
}
