//
//  ObservableArrayNotificationsTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 13/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class ObservableArrayNotificationsTest: XCTestCase, ObservableArrayDelegate {

  var itemAddedNotification: (String, Int)?
  var itemRemovedNotification: (String, Int)?
  
  override func setUp() {
    itemAddedNotification = nil
    itemRemovedNotification = nil
  }
  
  func test_append() {
    var observable: ObservableArray = ["one"]
    observable.delegate = self
    
    observable.append("bob")
    
    XCTAssertTrue("bob" == itemAddedNotification!.0)
    XCTAssertEqual(1, itemAddedNotification!.1)
  }
  
  func test_removeLast() {
    var observable: ObservableArray = ["one", "two"]
    observable.delegate = self
    
    observable.removeLast()
    
    XCTAssertTrue("two" == itemRemovedNotification!.0)
    XCTAssertEqual(1, itemRemovedNotification!.1)
  }
  
  func test_removeAtIndex() {
    var observable: ObservableArray = ["one", "two", "three"]
    observable.delegate = self
    
    observable.removeAtIndex(1)
    
    XCTAssertTrue("two" == itemRemovedNotification!.0)
    XCTAssertEqual(1, itemRemovedNotification!.1)
  }
  
  func test_insert() {
    var observable: ObservableArray = ["one", "two"]
    observable.delegate = self
    
    observable.insert("three", atIndex: 1)
    
    XCTAssertTrue("three" == itemAddedNotification!.0)
    XCTAssertEqual(1, itemAddedNotification!.1)
  }
  
  func didAddItem(item: Any, atIndex: Int, array: Any) {
    itemAddedNotification = (item as String, atIndex)
  }
  
  func didRemoveItem(item: Any, atIndex: Int, array: Any) {
    itemRemovedNotification = (item as String, atIndex)
  }
}
