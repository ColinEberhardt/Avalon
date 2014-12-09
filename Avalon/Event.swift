//
//  Event.swift
//  SwiftPlaces
//
//  Created by Colin Eberhardt on 27/11/2014.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

import Foundation
import Avalon

/// An event provides a mechanism for raising notifications. Multiple function
/// handlers can be added, with each being invoked when the event is raised.
public class Event {
  public typealias Handler = () -> ()
  
  private var handlers = [Handler]()
  
  public init() {
  }
  
  /// Raises the event, invoking all handlers
  public func raiseEvent() {
    for handler in handlers {
      handler()
    }
  }
  
  /// Adds the given handler
  public func addHandler(handler: Handler) {
    handlers.append(handler)
  }
}

/// An event provides a mechanism for raising notifications, together with some
/// associated data. Multiple function handlers can be added, with each being invoked,
/// with the event data, when the event is raised.
public class DataEvent<T> {
  public typealias Handler = T -> ()
  
  private var handlers = [Handler]()
  
  public init() {
  }
  
  /// Raises the event, invoking all handlers
  public func raiseEvent(data: T) {
    for handler in handlers {
      handler(data)
    }
  }
  
  /// Adds the given handler
  public func addHandler(handler: Handler) {
    handlers.append(handler)
  }
}

/// Adds a handler to an event
public func += <T> (left: DataEvent<T>, right: T -> ()) {
  left.addHandler(right)
}

/// Adds a handler to an event
public func += (left: Event, right: () -> ()) {
  left.addHandler(right)
}