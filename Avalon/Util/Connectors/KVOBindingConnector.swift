//
//  KVOBinding.swift
//  Avalon
//
//  Created by Colin Eberhardt on 09/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import ObjectiveC

// Binds a property on the source object to a property on the destination
// this class also ensures some sanity checks are performed
// 1. That the source property can be read
// 2. That the destination property is compatible with values emitted by the source
public class KVOBindingConnector: NSObject, Disposable {
  
  struct Context {
    static var kvoContext: UInt8 = 1
  }
  
  private var isSubscribed = false
  private let destination: NSObject, source: NSObject
  private let binding: Binding
  
  public init?(source: NSObject, destination: NSObject, binding: Binding) {
    
    self.destination = destination
    self.source = source
    self.binding = binding
    
    super.init()
    

    
    if binding.sourceProperty != "." {
      
      // subscribe for changes
      let subscriptionResult = AVKeyValueObservingHelper.addObserver(self, forKeyPath: binding.sourceProperty, options: NSKeyValueObservingOptions.New, context: &Context.kvoContext, forObject: source)
     
      if subscriptionResult != nil {
        ErrorSink.instance.logEvent("ERROR: Unable to add an observer to the source \(source) for binding \(binding) due to expception \(subscriptionResult.exception)")
        return nil
      }
      
      // record the fact that KVO has been succesfully set up
      isSubscribed = true
      
      // copy initial value - verifying that the source property path is valid
      let wrappedResults: AVValueWrapper =  AVKeyValueObservingHelper.tryGetValueForKeyPath(binding.sourceProperty, forObject: source)
      if let exception = wrappedResults.exception {
        ErrorSink.instance.logEvent("ERROR: Unable to get value from source \(source) for binding \(binding) due to exception \(exception)")
        return nil
      } else {
        if let error = setValueOnDestination(wrappedResults.propertyValue) {
          logError(wrappedResults.propertyValue)
          return nil
        }
      }
    } else {
      if let error = setValueOnDestination(source) {
        logError(source)
        return nil
      }
    }
  }
  
  private func logError(value: AnyObject?) {
    ErrorSink.instance.logEvent("ERROR: Unable to set value \(value) on destination \(destination) with binding \(binding) - does the property \(binding.destinationProperty) exist on the destination?")
  }
  
  override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
    change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    
    if context == &Context.kvoContext {
      let newValue: AnyObject = change[NSKeyValueChangeNewKey]!
      setValueOnDestination(newValue)
    } else {
      super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
    
  }
  
  private func setValueOnDestination(value: AnyObject?) -> String? {
    let convertedValue: AnyObject? = convertValue(value)
    
    // verify that the destination property accomodates this value
    /*if let warnings = KVCVerification.verifyCanSetVale(convertedValue, propertyPath: binding.destinationProperty, destination: destination) {
      ErrorSink.instance.logEvent(warnings)
    }*/
    
    return executeOnMainThread {
      () -> String? in
      let result = AVKeyValueObservingHelper.trySetValue(convertedValue, forKeyPath: self.binding.destinationProperty, forObject: self.destination)
      if result != nil {
        self.logError(value)
      }
      return result
    }
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