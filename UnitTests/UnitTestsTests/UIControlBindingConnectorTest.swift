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
    let connector = UIControlBindingConnector(source: person, destination: switchControl, valueExtractor: { switchControl.on }, binding: binding)
    
    // verify initial state
    XCTAssertTrue(switchControl.on)
    XCTAssertTrue(person.isFemale)
    
    // udate the control state
    switchControl.on = false
    connector.valueChanged()
    
    XCTAssertFalse(person.isFemale)
  }
  
  class StringToBool: NSValueTransformer {
    
    override func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
      if let stringValue = sourceValue as? String {
        return stringValue == "true"
      }
      return false
    }
    
    override func reverseTransformedValue(sourceValue: AnyObject?) -> AnyObject? {
      if let boolValue = sourceValue as? Bool {
        return boolValue ? "true" : "false"
      }
      return "false"
    }
  }
  
  func test_supportsValueConversion() {
    
    // create source and destination objects
    var person = PersonViewModel()
    person.name = "false"
    let switchControl = UISwitch()
    switchControl.on = false
    
    // create the binding that defines the property paths
    let binding = Binding(source: "name", destination: "on", transformer: StringToBool())
    
    // create the connector
    let connector = UIControlBindingConnector(source: person, destination: switchControl, valueExtractor: { switchControl.on }, binding: binding)
    
    // udate the control state
    switchControl.on = true
    connector.valueChanged()
    
    XCTAssertEqual(person.name, "true")
  }
  
  func failing_test_failsIfIncompatibleType() {
    // unfortunately this cannot be implemented, the KVC setValue method is very forgiving
    // instead we rely on KVCVerification, which tries its best to warn of comatibility issues
    XCTAssertTrue(false)
  }
  
  func test_failsIfInvalidPropertyPath() {
    AssertLogsError("ERROR: Unable to set value Optional(0) on destination") {
      // create source and destination objects
      var person = PersonViewModel()
      person.name = "Bill"
      let switchControl = UISwitch()
      switchControl.on = true
      
      // create the binding that defines the property paths
      let binding = Binding(source: "not-a-property", destination: "on")
      
      // create the connector
      let connector = UIControlBindingConnector(source: person, destination: switchControl, valueExtractor: { switchControl.on }, binding: binding)
      
      // verify initial state
      XCTAssertTrue(switchControl.on)
      XCTAssertTrue(person.isFemale)
      
      // udate the control state
      switchControl.on = false
      connector.valueChanged()
    }
  }
}
