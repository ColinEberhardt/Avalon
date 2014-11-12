//
//  KVOBinding.swift
//  Avalon
//
//  Created by Colin Eberhardt on 09/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import ObjectiveC

// binds a property on the source object to a property on the destination
class KVOBindingConnector: NSObject, Disposable {
  
  private var isSubscribed = true
  private let destination: NSObject, source: NSObject
  private let binding: Binding
  
  init(source: NSObject, destination: NSObject, binding: Binding) {
    
    self.destination = destination
    self.source = source
    self.binding = binding
    
    super.init()
    
    // subscribe for changes
    source.addObserver(self, forKeyPath: binding.sourceProperty, options: NSKeyValueObservingOptions.New, context: nil)
    
    // copy initial value
    let initialValue: AnyObject? = source.valueForKeyPath(binding.sourceProperty)
    setValueOnDestination(initialValue)
  }
  
  override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
    change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    
    let newValue: AnyObject = change[NSKeyValueChangeNewKey]!
    setValueOnDestination(newValue)
  }
  
  private func setValueOnDestination(value: AnyObject?) {
    let convertedValue: AnyObject? = convertValue(value)
    if let warnings = KVCVerification.verifyCanSetVale(convertedValue, propertyPath: binding.destinationProperty, destination: destination) {
      println(warnings)
    }
    destination.setValue(convertedValue, forKeyPath: binding.destinationProperty)
  }
  
    
  private func convertValue(value: AnyObject?) -> AnyObject? {
    if value != nil && binding.converter != nil {
      return binding.converter!.convert(value!)
    } else {
      return value
    }
  }
  
  func dispose() {
    if isSubscribed {
      source.removeObserver(self, forKeyPath: binding.sourceProperty)
      isSubscribed = false
    }
  }
  
  deinit {
    dispose()
  }
}