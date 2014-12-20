//
//  ViewModelBase.swift
//  Avalon
//
//  Created by Colin Eberhardt on 27/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

/// An optional base class for view model implementations. This base class
/// allows you to observe changes in property values without using
/// KVO directly.
public class ViewModelBase: NSObject {
  
  private var propertyObservers = [String]()
  
  private struct Context {
    static var kvoContext: UInt8 = 1
  }
  
  
  private let propertyChangedEvent = DataEvent<String>()
  
  deinit {
    for property in propertyObservers {
      self.removeObserver(self, forKeyPath: property)
    }
  }
  
  /// Add an observer to the given property
  public func addPropertyObserver<U: AnyObject>(properties: [String], _ target: U, handler: (U) -> (String) -> ()) -> Disposable {
    for propertyName in properties {
      self.addObserver(self, forKeyPath: propertyName,
        options: NSKeyValueObservingOptions.New, context: &Context.kvoContext)
    }
    propertyObservers += properties
    
    return propertyChangedEvent.addHandler(target, handler)
  }
  
  
  override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
    change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
      
    if context == &Context.kvoContext {
      propertyChangedEvent.raiseEvent(keyPath)
    } else {
      super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
  }
}