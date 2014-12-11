//
//  UIView+Extension.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 04/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import ObjectiveC
import Foundation
import UIKit

// MARK:- Public API
extension UIView: Bindable {
  
  @IBInspectable public var source: String {
    get {
      let value: AnyObject! = objc_getAssociatedObject(self, &AssociationKey.source)
      return value != nil ? value as String : ""
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.source, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  @IBInspectable public var destination: String {
    get {
      let value: AnyObject! = objc_getAssociatedObject(self, &AssociationKey.destination)
      return value != nil ? value as String : ""
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.destination, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  @IBInspectable public var converter: String {
    get {
      let value: AnyObject! = objc_getAssociatedObject(self, &AssociationKey.converter)
      return value != nil ? value as String : ""
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.converter, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  @IBInspectable public var mode: String {
    get {
      let value: AnyObject! = objc_getAssociatedObject(self, &AssociationKey.mode)
      return value != nil ? value as String : ""
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.mode, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  // for some reason the test build fails if this property is public
  // I need to dig into this in order to file a bug with Apple
  public var bindings: [Binding]? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.binding) as? [Binding]
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.binding, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
}

