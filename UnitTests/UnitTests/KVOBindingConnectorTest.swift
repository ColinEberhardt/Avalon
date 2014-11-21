//
//  KVOBindingConnectorTest.swift
//  Avalon
//
//  Created by Colin Eberhardt on 12/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import Avalon


class KVOBindingConnectorTest: XCTestCase {
  
  func test_init_copiesSourceValueToDestination() {
    
    // create source and destination objects
    var person = PersonViewModel()
    person.name = "Bill"
    let textField = UITextField()
    
    // create the binding that defines the property paths
    let binding = Binding(source: "name", destination: "text")

    // create the connector
    let connector = KVOBindingConnector(source: person, destination: textField, binding: binding)
    
    // verify
    XCTAssertEqual(textField.text!, "Bill")
  }
  
  func test_dotBinding() {
    
    // create source and destination objects
    var model = "hello"
    let textField = UITextField()
    
    // create the binding that defines the property paths
    let binding = Binding(source: ".", destination: "text")
    
    // create the connector
    let connector = KVOBindingConnector(source: model, destination: textField, binding: binding)
    
    // verify
    XCTAssertEqual(textField.text!, "hello")
  }
  
  func test_sourceProperty_failsIfInvalid() {
    // create source and destination objects
    var person = PersonViewModel()
    person.name = "Bill"
    let textField = UITextField()
    
    // create the binding that defines the property paths
    let binding = Binding(source: "not-valid-path", destination: "text")
    
    // create the connector
    let connector = KVOBindingConnector(source: person, destination: textField, binding: binding)
    XCTAssertNil(connector)
  }
  
  func test_destinationProperty_failsIfInvalidPropertyPath() {
    // create source and destination objects
    var person = PersonViewModel()
    person.name = "Bill"
    let textField = UITextField()
    
    // create the binding that defines the property paths
    let binding = Binding(source: "name", destination: "not-valid-path")
    
    // create the connector
    let connector = KVOBindingConnector(source: person, destination: textField, binding: binding)
    XCTAssertNil(connector)
  }
  
  func test_destinationProperty_failsIfIncompatibleType() {
    // unfortunately this cannot be implemented, the KVC setValue method is very forgiving
    // instead we rely on KVCVerification, which tries its best to warn of comatibility issues
    XCTAssertTrue(false)
  }
}
