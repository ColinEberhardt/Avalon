//
//  ObservableArrayTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 12/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class ObservableArrayTest: XCTestCase {
  
  var array: [String]!
  var observableArray: ObservableArray<String>!
  
  override func setUp() {
    array = [String]()
    observableArray = ObservableArray<String>()
  }
  
  func test_append() {
    array.append("1")
    observableArray.append("1")
    assert()
  }
  
  func test_count() {
    XCTAssertEqual(array.count, observableArray.count)
    array.append("1")
    observableArray.append("1")
    XCTAssertEqual(array.count, observableArray.count)
  }
  
  func test_first() {
    XCTAssertNil(array.first)
    XCTAssertNil(observableArray.first)
    array.append("1")
    observableArray.append("1")
    XCTAssertEqual(array.first!, observableArray.first!)
  }
  
  func test_last() {
    XCTAssertNil(array.last)
    XCTAssertNil(observableArray.last)
    array.append("1")
    observableArray.append("1")
    XCTAssertEqual(array.last!, observableArray.last!)
  }
  
  func test_capacity() {
    XCTAssertEqual(array.capacity, observableArray.capacity)
    array.append("1")
    observableArray.append("1")
    XCTAssertEqual(array.capacity, observableArray.capacity)
  }
  
  func test_isEmpty() {
    XCTAssertEqual(array.isEmpty, observableArray.isEmpty)
    array.append("1")
    observableArray.append("1")
    XCTAssertEqual(array.isEmpty, observableArray.isEmpty)
  }
  
  func test_removeLast() {
    observableArray = ["one", "two"]
    array = ["one", "two"]
    
    XCTAssertEqual("two", observableArray.removeLast())
    XCTAssertEqual("two", array.removeLast())
    assert()
  }
  
  func test_insert() {
    observableArray = ["one", "two"]
    array = ["one", "two"]
    
    observableArray.insert("three", atIndex: 1)
    array.insert("three", atIndex: 1)
    
    assert()
  }
  
  func test_removeAtIndex() {
    observableArray = ["one", "two", "three"]
    array = ["one", "two", "three"]
    
    observableArray.removeAtIndex(1)
    array.removeAtIndex(1)
    
    assert()
  }
  
  func test_arrayLiteral() {
    observableArray = ["one", "two"]
    array = ["one", "two"]
    assert()
  }
  
  func assert() {
    XCTAssertEqual(array.count, observableArray.count)
    
    var arrayGen = array.generate()
    var observableArrayGen = observableArray.generate()
    while let arrayItem = arrayGen.next() {
      if let observableArrayItem = observableArrayGen.next() {
        XCTAssertEqual(arrayItem, observableArrayItem)
      } else {
        XCTAssertTrue(false)
      }
    }
  }
}
