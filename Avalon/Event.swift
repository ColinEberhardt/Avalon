//
//  Event.swift
//  SwiftPlaces
//
//  Created by Colin Eberhardt on 27/11/2014.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

import Foundation


//MARK: - Public API

/// An event provides a mechanism for raising notifications. Multiple function
/// handlers can be added, with each being invoked when the event is raised.
public class Event {
  
  public typealias Handler = () -> ()
  
  private var handlers = [Invocable]()
  
  public init() {
  }
  
  /// Raises the event, invoking all handlers
  public func raiseEvent() {
    for handler in handlers {
      handler.invoke()
    }
  }
  
  /// Adds the given handler
  public func addHandler<T: AnyObject>(target: T, handler: (T) -> Handler) -> Disposable {
    var actionWrapper = HandlerWrapper(target: target, handler: handler)
    
    handlers.append(actionWrapper)
    
    actionWrapper.disposal = {
      removeHandler(&self.handlers, actionWrapper)
    }
    return actionWrapper
  }
}

/// An event provides a mechanism for raising notifications, together with some
/// associated data. Multiple function handlers can be added, with each being invoked,
/// with the event data, when the event is raised.
public class DataEvent<T> {
  
  public typealias Handler = T -> ()
  
  private var handlers = [DataInvocable]()
  
  public init() {
  }
  
  /// Raises the event, invoking all handlers
  public func raiseEvent(data: T) {
    executeOnMainThread {
      for handler in self.handlers {
        handler.invoke(data)
      }
    }
  }
  
  /// Adds the given handler
  public func addHandler<U: AnyObject>(target: U, handler: (U) -> Handler) -> Disposable {
    var actionWrapper = DataHandlerWrapper(target: target, handler: handler)
    
    handlers.append(actionWrapper)
    
    actionWrapper.disposal = {
      removeHandler(&self.handlers, actionWrapper)
    }
    return actionWrapper
  }
}

// MARK:- Private

// A protocol for a type that can be invoked
private protocol Invocable: class {
  func invoke()
}

// A protocol for a type that can be invoked
private protocol DataInvocable: class {
  func invoke(Any)
}

// takes a reference to a handler, as a class method, allowing
// a weak reference to the owning type.
// see: http://oleb.net/blog/2014/07/swift-instance-methods-curried-functions/
private class DataHandlerWrapper<T: AnyObject, U> : DataInvocable, Disposable {
  weak var target: T?
  let handler: (T) -> (U) -> ()
  var disposal: (()->())!
  
  init(target: T?, handler: (T) -> (U) -> ()){
    self.target = target
    self.handler = handler
  }
  
  func invoke(data: Any) -> () {
    if let t = target {
      handler(t)(data as U)
    }
  }
  
  func dispose() {
    disposal()
  }
}

// takes a reference to a handler, as a class method, allowing
// a weak reference to the owning type.
// see: http://oleb.net/blog/2014/07/swift-instance-methods-curried-functions/
private class HandlerWrapper<T: AnyObject> : Invocable, Disposable {
  weak var target: T?
  let handler: (T) -> () -> ()
  var disposal: (()->())!
  
  init(target: T?, handler: (T) -> () -> ()){
    self.target = target
    self.handler = handler
  }
  
  func invoke() -> () {
    if let t = target {
      handler(t)()
    }
  }
  
  func dispose() {
    disposal()
  }
}

private func removeHandler(inout handlers: [Invocable], handler: Invocable) {
  for i in 0..<handlers.count {
    if handlers[i] === handler {
      handlers.removeAtIndex(i)
      return
    }
  }
}

private func removeHandler(inout handlers: [DataInvocable], handler: DataInvocable) {
  for i in 0..<handlers.count {
    if handlers[i] === handler {
      handlers.removeAtIndex(i)
      return
    }
  }
}
