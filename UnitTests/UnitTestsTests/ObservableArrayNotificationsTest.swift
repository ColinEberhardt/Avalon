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

class ObservableArrayNotificationsTest: XCTestCase {

  var itemAddedNotification: (String, Int)?
  var itemRemovedNotification: (String, Int)?
  
  override func setUp() {
    itemAddedNotification = nil
    itemRemovedNotification = nil
  }
  
  func test_append() {
    var observable: ObservableArray = ["one"]
    observable.arrayChangedEvent.addHandler(self, handler: ObservableArrayNotificationsTest.arrayUpdated)
    
    observable.append("bob")
    
    XCTAssertTrue("bob" == itemAddedNotification!.0)
    XCTAssertEqual(1, itemAddedNotification!.1)
  }
  
  func test_removeLast() {
    var observable: ObservableArray = ["one", "two"]
    observable.arrayChangedEvent.addHandler(self, handler: ObservableArrayNotificationsTest.arrayUpdated)
    
    observable.removeLast()
    
    XCTAssertTrue("two" == itemRemovedNotification!.0)
    XCTAssertEqual(1, itemRemovedNotification!.1)
  }
  
  func test_removeAtIndex() {
    var observable: ObservableArray = ["one", "two", "three"]
    observable.arrayChangedEvent.addHandler(self, handler: ObservableArrayNotificationsTest.arrayUpdated)
    
    observable.removeAtIndex(1)
    
    XCTAssertTrue("two" == itemRemovedNotification!.0)
    XCTAssertEqual(1, itemRemovedNotification!.1)
  }
  
  func test_insert() {
    var observable: ObservableArray = ["one", "two"]
    observable.arrayChangedEvent.addHandler(self, handler: ObservableArrayNotificationsTest.arrayUpdated)
    
    observable.insert("three", atIndex: 1)
    
    XCTAssertTrue("three" == itemAddedNotification!.0)
    XCTAssertEqual(1, itemAddedNotification!.1)
  }
  
  func arrayUpdated(update: ArrayUpdateType) {
    switch update {
    case .ItemAdded(let index, let item):
      itemAddedNotification = (item as String, index)
      break
    case .ItemRemoved(let index, let item):
      itemRemovedNotification = (item as String, index)
      break
    }
  }
  
  func didAddItem(item: AnyObject, atIndex index: Int, inArray array: ObservableArray) {
    itemAddedNotification = (item as String, index)
  }
  
  func didRemoveItem(item: AnyObject, atIndex index: Int, inArray array: ObservableArray) {
    itemRemovedNotification = (item as String, index)
  }
}
