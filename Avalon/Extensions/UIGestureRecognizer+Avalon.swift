//
//  UIGestureRecognizer+Avalon.swift
//  Avalon
//
//  Created by Colin Eberhardt on 16/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

private var command2AssociationKey: UInt8 = 6

extension UIGestureRecognizer: Bindable {
  
  @IBInspectable public var source: String {
    get {
      let value: AnyObject! = objc_getAssociatedObject(self, &sourceAssociationKey)
      return value != nil ? value as String : ""
    }
    set(newValue) {
      objc_setAssociatedObject(self, &sourceAssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  @IBInspectable public var destination: String {
    get {
      let value: AnyObject! = objc_getAssociatedObject(self, &destinationAssociationKey)
      return value != nil ? value as String : ""
    }
    set(newValue) {
      objc_setAssociatedObject(self, &destinationAssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  @IBInspectable public var converter: String {
    get {
      let value: AnyObject! = objc_getAssociatedObject(self, &converterAssociationKey)
      return value != nil ? value as String : ""
    }
    set(newValue) {
      objc_setAssociatedObject(self, &converterAssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  @IBInspectable public var mode: String {
    get {
      let value: AnyObject! = objc_getAssociatedObject(self, &modeAssociationKey)
      return value != nil ? value as String : ""
    }
    set(newValue) {
      objc_setAssociatedObject(self, &modeAssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  // for some reason the test build fails if this property is public
  // I need to dig into this in order to file a bug with Apple
  public var bindings: [Binding]? {
    get {
      return objc_getAssociatedObject(self, &bindingAssociationKey) as? [Binding]
    }
    set(newValue) {
      objc_setAssociatedObject(self, &bindingAssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  public var command: Command? {
    get {
      return objc_getAssociatedObject(self, &command2AssociationKey) as Command?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &command2AssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
      
      // TODO: Ensure this is a one-time subscription
      self.addTarget(self, action: "gestureFired")
    }
  }
  
  func gestureFired() {
    if let buttonCommand = command {
      buttonCommand.execute()
    }
  }
  
}