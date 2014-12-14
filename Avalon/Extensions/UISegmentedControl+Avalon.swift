//
//  UISegmentedControl+Binding.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 08/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Public API
extension UISegmentedControl: ObservableArrayDelegate {
  
  /// An bindable array of strings that represent the segment titles
  public var segments: AnyObject? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.segments)
    }
    set(newValue) {
      
      let oldValue: AnyObject? = segments
      
      objc_setAssociatedObject(self, &AssociationKey.segments, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
      
      if let segments = newValue as? [String] {
        removeAllSegments()
        var index = 0
        for item in segments {
          insertSegmentWithTitle(item, atIndex: index, animated: false)
          index++
        }
      } else if let segments = newValue as? ObservableArray {
        
        segments.delegate = self
        
        removeAllSegments()
        var index = 0
        for item in segments {
          if let item = item as? String {
            insertSegmentWithTitle(item, atIndex: index, animated: false)
            index++
          }
        }
      }
      
      if let oldObservableArray = oldValue as? ObservableArray {
        if oldObservableArray.delegate === self {
          oldObservableArray.delegate = nil
        }
      }
    }
  }
  
  public func didAddItem(item: AnyObject, atIndex index: Int, inArray array: ObservableArray) {
    if let item = item as? String {
      insertSegmentWithTitle(item, atIndex: index, animated: true)
    }
  }
  
  public func didRemoveItem(item: AnyObject, atIndex index: Int, inArray array: ObservableArray) {
    removeSegmentAtIndex(index, animated: true)
  }
}