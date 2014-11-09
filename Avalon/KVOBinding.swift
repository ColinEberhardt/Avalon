//
//  KVOBinding.swift
//  Avalon
//
//  Created by Colin Eberhardt on 09/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// binds a property on the source object to a property on the destination
class KVOBinding: NSObject, Disposable {
  
  private var isSubscribed = true
  private let destination: NSObject, source: NSObject
  private let destinationKeyPath: String, sourceKeyPath: String
  private let converter: ValueConverter?
  
  init(source: NSObject, sourceKeyPath: String, destination: NSObject,
    destinationKeyPath: String, converter: ValueConverter?) {
    
    self.converter = converter
    self.destination = destination
    self.source = source
    self.destinationKeyPath = destinationKeyPath
    self.sourceKeyPath = sourceKeyPath
    
    super.init()
    
    // subscribe for changes
    source.addObserver(self, forKeyPath: sourceKeyPath, options: NSKeyValueObservingOptions.New, context: nil)
    
    // copy initial value
    let initialValue: AnyObject? = source.valueForKeyPath(sourceKeyPath)
    destination.setValue(convertValue(initialValue), forKeyPath: destinationKeyPath)
  }
  
  convenience init(source: NSObject, sourceKeyPath: String, destination: NSObject,
    destinationKeyPath: String) {
    self.init(source: source, sourceKeyPath: sourceKeyPath, destination: destination,
      destinationKeyPath: destinationKeyPath, converter: nil)
  }
  
  override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
    change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    
    let newValue: AnyObject = change[NSKeyValueChangeNewKey]!
    destination.setValue(convertValue(newValue), forKeyPath: destinationKeyPath)
  }
  
  func convertValue(value: AnyObject?) -> AnyObject? {
    if value != nil && converter != nil {
      return converter!.convert(value!)
    } else {
      return value
    }
  }
  
  func dispose() {
    if isSubscribed {
      source.removeObserver(self, forKeyPath: sourceKeyPath)
      isSubscribed = false
    }
  }
  
  deinit {
    dispose()
  }
}