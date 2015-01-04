//
//  UIView+DelegateMulticast.swift
//  Avalon
//
//  Created by Colin Eberhardt on 11/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

extension UIView {
  
  // an associated boolean property that is set to true when didMoveToWindow occurs
  var viewInitialized: Bool {
    get {
      return getAssociatedProperty(self, &AssociationKey.viewInitialized, false)
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.viewInitialized, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
}