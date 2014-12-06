//
//  UISegmentedControl+Binding.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 08/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
  
  public var segments: [String]? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.segments) as [String]?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.segments, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
      
      // TODO: Allow this to observe changes in the segments
      removeAllSegments()
      var index = 0
      for item in newValue! {
        insertSegmentWithTitle(item, atIndex: index, animated: false)
        index++
      }
    }
  }
}