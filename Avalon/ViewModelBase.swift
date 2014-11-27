//
//  ViewModelBase.swift
//  Avalon
//
//  Created by Colin Eberhardt on 27/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

public typealias EventHandler = () -> ()

// Adds very crude property and event observation
// TODO: Make these observers multicast
public class ViewModelBase: NSObject {
  
  private var eventHandlers = [String:EventHandler]()

  private var kvoHandlers = [String:EventHandler]()
  
  public func addEventHandler(eventName: String, handler: EventHandler) {
    eventHandlers[eventName] = handler
  }
  
  public func addPropertyObserver(propertyName: String, handler: EventHandler) {
    
    self.addObserver(self, forKeyPath: propertyName,
      options: NSKeyValueObservingOptions.New, context: nil)

    kvoHandlers[propertyName] = handler
  }
  
  override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
    change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    if let handler = kvoHandlers[keyPath] {
      handler()
    }
  }
  
  public func raiseEvent(eventName: String) {
    if let handler = eventHandlers[eventName] {
      handler()
    }
  }
}