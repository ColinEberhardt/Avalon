//
//  Event.swift
//  SwiftPlaces
//
//  Created by Colin Eberhardt on 27/11/2014.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

import Foundation
import Avalon

public class EmptyEvent {
  typealias Handler = () -> ()
  
  private var handlers = [Handler]()
  
  public init() {
  }
  
  public func raiseEvent() {
    for handler in handlers {
      handler()
    }
  }
  
  func addHandler(handler: Handler) {
    handlers.append(handler)
  }
}

public class Event<T> {
  typealias Handler = T -> ()
  
  private var handlers = [Handler]()
  
  public init() {
  }
  
  public func raiseEvent(data: T) {
    for handler in handlers {
      handler(data)
    }
  }
  
  func addHandler(handler: Handler) {
    handlers.append(handler)
  }
}

public func += <T> (left: Event<T>, right: T -> ()) {
  left.addHandler(right)
}

public func += (left: EmptyEvent, right: () -> ()) {
  left.addHandler(right)
}