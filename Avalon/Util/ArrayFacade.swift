//
//  ArrayFacade.swift
//  Avalon
//
//  Created by Colin Eberhardt on 18/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// Controls / views that support collection binding allow either an array of items
// or an ObservableArray to be suppied as the source of items. Unfortunately there is
// not a common interface between Array and ObservableArray, hence this adapter
// is used to provide a common interface
protocol ArrayFacade {
  var count: Int { get }
  func itemAtIndex(index: Int) -> NSObject
}

func facadeForArray(items: AnyObject?) -> ArrayFacade! {
  if let items = items as? NSArray {
    return SwiftArrayFacade(items: items)
  } else if let items = items as? ObservableArray {
    return ObservableArrayFacade(items: items)
  } else {
    ErrorSink.instance.logEvent("ERROR: collection binding (e.g. table view items, segemnted control segments) only works for Arrays or ObservableArrays, the following is not a valid property value \(items)")
    return nil
  }
}

class ObservableArrayFacade: ArrayFacade {
  let items: ObservableArray
  init(items: ObservableArray) {
    self.items = items
  }
  
  var count: Int {
    return items.count
  }
  
  func itemAtIndex(index: Int) -> NSObject {
    return items[index] as NSObject
  }
}

class SwiftArrayFacade: ArrayFacade {
  let items: NSArray
  init(items: NSArray) {
    self.items = items
  }
  
  var count: Int {
    return items.count
  }
  
  func itemAtIndex(index: Int) -> NSObject {
    return items[index] as NSObject
  }
}