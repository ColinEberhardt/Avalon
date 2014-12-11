//
//  UIView+DelegateMulticast.swift
//  Avalon
//
//  Created by Colin Eberhardt on 11/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

extension UIView {
  
  // an abstract function that is overriden to perform the actual switch
  func replaceDelegateWithMultiplexer() {
  }
  
  // funny things happen if the delegate is switched before the table view renders
  // for this reason the switch occurs when didMoveToWindow is invoked.
  func override_didMoveToWindow() {
    
    if (!viewInitialized) {
      replaceDelegateWithMultiplexer()
      viewInitialized = true
    }
    
    self.override_didMoveToWindow()
  }
  
  // an associated boolean property that is set to true when didMoveToWindow occurs
  var viewInitialized: Bool {
    get {
      let viewInitialized = objc_getAssociatedObject(self, &AssociationKey.viewInitialized) as Bool?
      if let viewInitialized = viewInitialized {
        return viewInitialized
      }
      return false
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.viewInitialized, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
}