//
//  ViewModelBase.swift
//  Avalon
//
//  Created by Colin Eberhardt on 27/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

public typealias EventHandler = () -> ()


public class ViewModelBase: NSObject {
  
  struct Context {
    static var kvoContext: UInt8 = 1
  }
  
  // Adds very crude property and event observation
  // TODO: Make these observers multicast

  private var kvoHandlers = [String:EventHandler]()
  
  public func addPropertyObserver(propertyName: String, handler: EventHandler) {
    
    self.addObserver(self, forKeyPath: propertyName,
      options: NSKeyValueObservingOptions.New, context: &Context.kvoContext)

    kvoHandlers[propertyName] = handler
  }
  
  override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
    change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
      
    if context == &Context.kvoContext {
      if let handler = kvoHandlers[keyPath] {
        handler()
      }
    } else {
      super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
  }
}