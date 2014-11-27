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
// this class also ensures some sanity checks are performed
// 1. That the source property can be read
// 2. That the destination property is compatible with values emitted by the source
public class KVOBindingConnector: NSObject, Disposable {
  
  private var isSubscribed = true
  private let destination: NSObject, source: NSObject
  private let binding: Binding
  
  public init?(source: NSObject, destination: NSObject, binding: Binding) {
    
    self.destination = destination
    self.source = source
    self.binding = binding
    
    super.init()
    
    if binding.sourceProperty != "." {
      
      // subscribe for changes
      source.addObserver(self, forKeyPath: binding.sourceProperty,
          options: NSKeyValueObservingOptions.New, context: nil)
      
      // copy initial value - verifying that the source property path is valid
      let wrappedResults: NSValueWrapper =  NSObjectHelper.tryGetValueForKeyPath(binding.sourceProperty, forObject: source)
      if let exception = wrappedResults.exception {
        ErrorSink.instance.logEvent("ERROR: Unable to get value from source \(source) for binding \(binding)")
        return nil
      } else {
        if let error = setValueOnDestination(wrappedResults.propertyValue) {
          ErrorSink.instance.logEvent("ERROR: Unable to set value \(wrappedResults.propertyValue) on destination \(destination) with binding \(binding)")
          return nil
        }
      }
    } else {
      if let error = setValueOnDestination(source) {
        ErrorSink.instance.logEvent("ERROR: Unable to set value \(source) on destination \(destination) with binding \(binding)")
        return nil
      }
    }
    
    
  }
  
  override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
    change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    
    let newValue: AnyObject = change[NSKeyValueChangeNewKey]!
    setValueOnDestination(newValue)
  }
  
  private func setValueOnDestination(value: AnyObject?) -> String? {
    let convertedValue: AnyObject? = convertValue(value)
    
    // verify that the destination property accomodates this value
    /*if let warnings = KVCVerification.verifyCanSetVale(convertedValue, propertyPath: binding.destinationProperty, destination: destination) {
      ErrorSink.instance.logEvent(warnings)
    }*/
    
    return NSObjectHelper.trySetValue(convertedValue, forKeyPath: binding.destinationProperty, forObject: destination)
  }
  
    
  private func convertValue(value: AnyObject?) -> AnyObject? {
    if binding.converter != nil {
      return binding.converter!.convert(value, binding: self.binding, viewModel: self.source)
    } else {
      return value
    }
  }
  
  public func dispose() {
    if isSubscribed && binding.sourceProperty != "." {
      source.removeObserver(self, forKeyPath: binding.sourceProperty)
      isSubscribed = false
    }
  }
  
  deinit {
    dispose()
  }
}