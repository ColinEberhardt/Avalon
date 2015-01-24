//
//  Command.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 07/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

/// Defines an action, typically an invocable view model property.
@objc public protocol Action {
  /// Invokes the action
  func execute()
}

/// An action that is defined by a closure supplied to the initializer
public class ClosureAction: Action {
  private let action: () -> ()
  
  public init(action: () -> ()) {
    self.action = action
  }
  
  public func execute() {
    action()
  }
}

/// Defines an action that conveys data
@objc public protocol DataAction {
  /// Invokes the action, with the supplied data
  func execute(data: AnyObject)
}

/// An action that is defined by a closure supplied to the initializer
public class ClosureDataAction: DataAction {
  private let action: AnyObject -> ()
  
  public init(action: AnyObject -> ()) {
    self.action = action
  }
  
  public func execute(data: AnyObject) {
    // TODO: use generics to perform the required cast?
    action(data)
  }
}

