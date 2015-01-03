//
//  ControlBinding.swift
//  Avalon
//
//  Created by Colin Eberhardt on 09/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit


// binds a UIControl so that value changes are propagated back to the source
// in TwoWay binding scenarios
public class UIControlBindingConnector: NSObject, Disposable {
  
  private var isSubscribed = true
  private let destination: UIControl, source: NSObject
  private let binding: Binding
  private let events: UIControlEvents
  private let valueExtractor: () -> AnyObject
  
  public init(source: NSObject, destination: UIControl, valueExtractor: () -> AnyObject, binding: Binding, events: UIControlEvents = .ValueChanged) {
    
    self.destination = destination
    self.source = source
    self.valueExtractor = valueExtractor
    self.binding = binding
    self.events = events
    
    super.init()
    
    // subscribe for changes
    destination.addTarget(self, action: "valueChanged", forControlEvents: events)
  }
  
  // TODO: Only made public for unit tests. It should be possible to fire this using target-action
  public func valueChanged() {
    var value: AnyObject? = valueExtractor()
    
    setValueFromBinding(value: value, binding: binding, source: destination, destination: source, destinationProperty: binding.sourceProperty, binding.transformer?.reverseTransformedValue)
  }
  
  public func dispose() {
    if isSubscribed {
      destination.removeTarget(self, action: "valueChanged", forControlEvents: events)
      isSubscribed = false
    }
  }
  
  deinit {
    dispose()
  }
}