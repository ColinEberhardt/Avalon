//
//  ArrayFacade.swift
//  Avalon
//
//  Created by Colin Eberhardt on 18/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// MARK: - items adapter classes
protocol ArrayFacade {
  var count: Int { get }
  func itemAtIndex(index: Int) -> NSObject
}

func facadeForArray(items: AnyObject?) -> ArrayFacade! {
  if let items = items as? NSArray {
    return SwiftArrayFacade(items: items)
  } else if let items = items as? ObservableArray {
    return ObservableArrayFacade(items: items)
  }
  return nil
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