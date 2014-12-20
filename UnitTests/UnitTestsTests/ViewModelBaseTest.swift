//
//  ViewModelBaseTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 18/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class TestViewModel: ViewModelBase {
  dynamic var propertyOne = "foo"
  dynamic var propertyTwo = "bar"
}

class ViewModelBaseTest: XCTestCase {
  
  var propertyChangedData = ""
  
  override func setUp() {
    propertyChangedData = ""
  }
  
  func test_propertyChangesAreObservable() {
    // add a handler to propertyOne
    var viewModel = TestViewModel()
    viewModel.addPropertyObserver(["propertyOne"], self, handler: ViewModelBaseTest.propertyChanged)
    
    // ensure only changes to this property are observed
    viewModel.propertyOne = "fish"
    XCTAssertEqual("propertyOne", propertyChangedData)
    
    propertyChangedData = ""
    viewModel.propertyTwo = "cat"
    XCTAssertEqual("", propertyChangedData)
  }
  
  func test_observeMultipleProperties() {
    // add a handler to propertyOne
    var viewModel = TestViewModel()
    viewModel.addPropertyObserver(["propertyOne"], self, handler: ViewModelBaseTest.propertyChanged)
    viewModel.addPropertyObserver(["propertyTwo"], self, handler: ViewModelBaseTest.propertyChanged)
    
    viewModel.propertyOne = "fish"
    XCTAssertEqual("propertyOne", propertyChangedData)
    
    viewModel.propertyTwo = "cat"
    XCTAssertEqual("propertyTwo", propertyChangedData)
  }
  
  func test_propertyChangesObserversCanBeDisposed() {
    // add a handler to propertyOne
    var viewModel = TestViewModel()
    let handler = viewModel.addPropertyObserver(["propertyOne"], self, handler: ViewModelBaseTest.propertyChanged)
    
    viewModel.propertyOne = "fish"
    XCTAssertEqual("propertyOne", propertyChangedData)
    
    propertyChangedData = ""
    handler.dispose()
    
    viewModel.propertyOne = "dog"
    XCTAssertEqual("", propertyChangedData)
  }
  
  func test_multipleSubscribers() {
    // add a handler to propertyOne
    var viewModel = TestViewModel()
    viewModel.addPropertyObserver(["propertyOne"], self, handler: ViewModelBaseTest.propertyChanged)
    viewModel.addPropertyObserver(["propertyOne"], self, handler: ViewModelBaseTest.propertyChanged)
  }
  
  func propertyChanged(propertyName: String) {
    propertyChangedData = propertyName
  }
}