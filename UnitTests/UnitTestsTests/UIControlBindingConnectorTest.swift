//
//  UIControlBindingConnectorTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 17/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import Avalon


class UIControlBindingConnectorTest: XCTestCase {
  
  func test_updatesToControlStatePropagateToViewModel() {
    
    // create source and destination objects
    var person = PersonViewModel()
    person.name = "Bill"
    let switchControl = UISwitch()
    switchControl.on = true
    
    // create the binding that defines the property paths
    let binding = Binding(source: "isFemale", destination: "on")
    
    // create the connector
    let connector = UIControlBindingConnector(source: person, destination: switchControl, valueExtractor: { switchControl.on }, binding: binding)!
    
    // verify initial state
    XCTAssertTrue(switchControl.on)
    XCTAssertTrue(person.isFemale)
    
    // udate the control state
    switchControl.on = false
    connector.valueChanged()
    
    XCTAssertFalse(person.isFemale)
  }
  
  func test_prohibitsDotBinding() {
    
    var error: String = ""
    func errorReporter(event: String) {
      error = event
    }
    ErrorSink.instance.setSink(errorReporter)
    
    // create source and destination objects
    var value = true
    let switchControl = UISwitch()
    switchControl.on = true
    
    // create the binding that defines the property paths
    let binding = Binding(source: ".", destination: "on")
    
    // create the connector
    let connector = UIControlBindingConnector(source: value, destination: switchControl, valueExtractor: { switchControl.on }, binding: binding)
    
    // verify an error was logged
    let range = error.rangeOfString("ERROR")
    XCTAssertTrue(range != nil)
  }
  
  func failing_test_failsIfIncompatibleType() {
    // unfortunately this cannot be implemented, the KVC setValue method is very forgiving
    // instead we rely on KVCVerification, which tries its best to warn of comatibility issues
    XCTAssertTrue(false)
  }
  
  func test_failsIfInvalidPropertyPath() {
    
    var error: String = ""
    func errorReporter(event: String) {
      error = event
    }
    ErrorSink.instance.setSink(errorReporter)
    
    // create source and destination objects
    var person = PersonViewModel()
    person.name = "Bill"
    let switchControl = UISwitch()
    switchControl.on = true
    
    // create the binding that defines the property paths
    let binding = Binding(source: "not-a-property", destination: "on")
    
    // create the connector
    let connector = UIControlBindingConnector(source: person, destination: switchControl, valueExtractor: { switchControl.on }, binding: binding)!
    
    // verify initial state
    XCTAssertTrue(switchControl.on)
    XCTAssertTrue(person.isFemale)
    
    // udate the control state
    switchControl.on = false
    connector.valueChanged()
    
    // verify an error was logged
    let range = error.rangeOfString("ERROR")
    XCTAssertTrue(range != nil)
  }
}
