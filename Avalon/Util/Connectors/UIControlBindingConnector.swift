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
    let value: AnyObject = valueExtractor()
  
    let maybeFailureMessage = AVKeyValueObservingHelper.trySetValue(value, forKeyPath: binding.sourceProperty, forObject: source)
    if let failureMessage = maybeFailureMessage {
      ErrorSink.instance.logEvent("ERROR: Unable to set value on destination \(destination) with binding \(binding)")
    }
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