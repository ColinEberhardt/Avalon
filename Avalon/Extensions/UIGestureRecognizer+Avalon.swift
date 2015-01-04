//
//  UIGestureRecognizer+Avalon.swift
//  Avalon
//
//  Created by Colin Eberhardt on 16/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

extension UIGestureRecognizer: Bindable {
  
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
  
  /// An action which is executed when the gesture occurs
  public var action: Action? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.action) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.action, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
      
      // this will get called each time an action is set, but the addTarget implementation ensures
      // that each action is only added once, so repeated calls are ignored
      self.addTarget(self, action: "gestureFired")
    }
  }
  
  func gestureFired() {
    if let buttonAction = action {
      buttonAction.execute()
    }
  }
  
}