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
  
  
  
  func test_binding_supportsSourcePropertyPaths() {
    
    // create source and destination objects
    let person = PersonViewModel()
    let label = UILabel()
    
    //
    let binding = Binding(source: "address.city", destination: "text")
    
    // create the connector
    let connector = KVOBindingConnector(source: person, destination: label, binding: binding)
    
    // verify state
    XCTAssertEqual(label.text!, "Newcastle")
  }
  
  func test_binding_propertyPathSupportsTargetUpdate() {
    
    // create source and destination objects
    let person = PersonViewModel()
    let label = UILabel()
    
    //
    let binding = Binding(source: "address.city", destination: "text")
    
    // create the connector
    let connector = KVOBindingConnector(source: person, destination: label, binding: binding)
    
    // verify state
    XCTAssertEqual(label.text!, "Newcastle")
    
    // mutate
    person.address.city = "Leeds"
    
    // verify
    XCTAssertEqual(label.text!, "Leeds")
  }
  
  func test_binding_propertyPathSupportsChangeInChain() {
    
    // create source and destination objects
    let person = PersonViewModel()
    let label = UILabel()
    
    //
    let binding = Binding(source: "address.city", destination: "text")
    
    // create the connector
    let connector = KVOBindingConnector(source: person, destination: label, binding: binding)
    
    // verify state
    XCTAssertEqual(label.text!, "Newcastle")
    
    // mutate
    let newAddress = AddressViewModel()
    newAddress.city = "Leeds"
    person.address = newAddress
    
    // verify
    XCTAssertEqual(label.text!, "Leeds")
  }
  
  func test_binding_supportsConstantProperties() {
    
    // create source and destination objects
    let person = PersonViewModel()
    let label = UILabel()
    
    //
    let binding = Binding(source: "surname", destination: "text")
    
    // create the connector
    let connector = KVOBindingConnector(source: person, destination: label, binding: binding)
    
    // verify state
    XCTAssertEqual(label.text!, "Eggbert")
  }
  
  func test_binding_updatesDestinationWhenSourceChanges() {
    
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
    
    // update the source
    person.name = "Frank"
    
    // verify that the destination is updated
    XCTAssertEqual(textField.text!, "Frank")
  }
  
  func test_binding_supportsDotSyntax() {
    
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
  
  func test_binding_failsIfPropertyPathContainsNonNSObject() {
    AssertLogsError("ERROR: Unable to add an observer to the source") {
      // create source and destination objects
      let person = PersonViewModel()
      let label = UILabel()
      
      //
      let binding = Binding(source: "badProperty.foo", destination: "text")
      
      // create the connector
      let connector = KVOBindingConnector(source: person, destination: label, binding: binding)
      XCTAssertNil(connector)
    }
  }
  
  func test_sourceProperty_failsIfInvalid() {
    AssertLogsError("ERROR: Unable to get value from source") {
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
  }
  
  func test_destinationProperty_failsIfInvalidPropertyPath() {
    AssertLogsError("ERROR: Unable to set value") {
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
  }
  
  func failing_test_destinationProperty_failsIfIncompatibleType() {
    // unfortunately this cannot be implemented, the KVC setValue method is very forgiving
    // instead we rely on KVCVerification, which tries its best to warn of comatibility issues
    XCTAssertTrue(false)
  }
}
