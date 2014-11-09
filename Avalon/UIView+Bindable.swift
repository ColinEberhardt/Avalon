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
  
  var binding: Binding? {
    if self.source != "" && self.destination != "" {
      
      // create a binding
      let binding = Binding(source: self.source, destination: self.destination)
      
      // add a converter
      if self.converter != "" {
        let converterClass = NSClassFromString(self.converter) as NSObject.Type
        binding.converter = converterClass() as ValueConverter
      }
      
      if self.mode == "TwoWay" {
        binding.mode = .TwoWay
      }
      
      return binding
    } else {
      return nil
    }
  }
}

