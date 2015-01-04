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
      return getAssociatedProperty(self, &AssociationKey.source, "")
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.source, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  @IBInspectable public var destination: String {
    get {
      return getAssociatedProperty(self, &AssociationKey.destination, "")
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.destination, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  @IBInspectable public var transformer: String {
    get {
      return getAssociatedProperty(self, &AssociationKey.transformer, "")
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.transformer, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  @IBInspectable public var mode: String {
    get {
      return getAssociatedProperty(self, &AssociationKey.mode, "")
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.mode, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  public var bindings: [Binding]? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.binding) as? [Binding]
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.binding, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }

  public var bindingFromBindable: Binding? {
    return lazyAssociatedProperty(self, &AssociationKey.bindingFromBindable) {
      return Binding.fromBindable(self)
    }
  }
}

