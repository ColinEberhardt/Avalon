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
  var itemUpdatedNotification: (String, Int)?
  var reset = false
  var notifications = ""
  
  override func setUp() {
    itemAddedNotification = nil
    itemRemovedNotification = nil
    notifications = ""
    reset = false
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
  
  func test_subscript() {
    var observable: ObservableArray = ["one", "two"]
    observable.arrayChangedEvent.addHandler(self, handler: ObservableArrayNotificationsTest.arrayUpdated)
    
    observable.insert("three", atIndex: 1)
    
    XCTAssertTrue("three" == itemAddedNotification!.0)
    XCTAssertEqual(1, itemAddedNotification!.1)
  }
  
  func test_extend() {
    var observable: ObservableArray = ["one", "two"]
    observable.arrayChangedEvent.addHandler(self, handler: ObservableArrayNotificationsTest.arrayUpdated)
    
    observable.extend(["three", "four"])
    
    XCTAssertEqual("three - 2four - 3", notifications)
  }
  
  func test_removeAll() {
    var observable: ObservableArray = ["one", "two"]
    observable.arrayChangedEvent.addHandler(self, handler: ObservableArrayNotificationsTest.arrayUpdated)
    
    observable.removeAll()
    
    XCTAssertTrue(reset)
  }
  
  func arrayUpdated(update: ArrayUpdateType) {
    switch update {
    case .ItemAdded(let index, let item):
      itemAddedNotification = (item as String, index)
      notifications += "\(item as String) - \(index)"
      break
    case .ItemRemoved(let index, let item):
      itemRemovedNotification = (item as String, index)
      break
    case .ItemUpdated(let index, let item):
      itemUpdatedNotification = (item as String, index)
      break
    case .Reset:
      reset = true
      break
    }
  }
  
}
