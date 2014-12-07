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
  
  public var bindings: [Binding]? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.binding) as? [Binding]
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.binding, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
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