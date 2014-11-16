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

private var bindingAssociationKey: UInt8 = 1
private var sourceAssociationKey: UInt8 = 2
private var destinationAssociationKey: UInt8 = 3
private var converterAssociationKey: UInt8 = 4
private var modeAssociationKey: UInt8 = 5

extension UIView {
  
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
  
  // take the publicly exposed binding components and construct
  // a binding instance
  var binding: Binding? {
    if self.source != "" && self.destination != "" {
      
      // create a binding
      let binding = Binding(source: self.source, destination: self.destination)
      
      // add a converter
      if self.converter != "" {
        if let converterClass = NSClassFromString(self.converter) as? NSObject.Type {
          binding.converter = converterClass() as? ValueConverter
        } else {
          println("ERROR: A converter of class \(self.converter) could not be constructed.")
        }
      }
      
      if self.mode == "TwoWay" {
        binding.mode = .TwoWay
      } else if self.mode == "OneWay" {
        binding.mode = .OneWay
      } else if self.mode != "" {
        println("ERROR: binding mode can only have values of OneWay or TwoWay, the value \(self.mode) is not permitted.")
      }
      
      return binding
    } else {
      return nil
    }
  }
}
