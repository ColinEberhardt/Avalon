//
//  ControlBinding.swift
//  Avalon
//
//  Created by Colin Eberhardt on 09/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

// binds a property on the source object to a property on the destination
class ControlBindingConnector: NSObject, Disposable {
  
  private var isSubscribed = true
  private let destination: UIControl, source: NSObject
  private let binding: Binding
  private let valueExtractor: () -> AnyObject
  
  init(source: NSObject, destination: UIControl, valueExtractor: () -> AnyObject, binding: Binding, events: UIControlEvents = .ValueChanged) {
    
      self.destination = destination
      self.source = source
      self.valueExtractor = valueExtractor
      self.binding = binding
      
      super.init()
      
      // subscribe for changes
      destination.addTarget(self, action: "valueChanged", forControlEvents: events)
  }
  
  
  public func valueChanged() {
      let value: AnyObject = valueExtractor()
      source.setValue(value, forKeyPath: binding.sourceProperty)
  }
  
  func dispose() {
    if isSubscribed {
      destination.removeTarget(self, action: "valueChanged", forControlEvents: UIControlEvents.ValueChanged)
      isSubscribed = false
    }
  }
  
  deinit {
    dispose()
  }
}