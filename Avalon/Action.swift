//
//  Command.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 07/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

@objc public protocol Action {
  func execute()
}

public class ClosureAction: Action {
  private let action: () -> ()
  
  public init(action: () -> ()) {
    self.action = action
  }
  
  public func execute() {
    action()
  }
}

@objc public protocol DataAction {
  func execute(data: AnyObject)
}

public class ClosureDataAction: DataAction {
  private let action: AnyObject -> ()
  
  public init(action: AnyObject -> ()) {
    self.action = action
  }
  
  public func execute(data: AnyObject) {
    // TODO: use generics to perform the rquired cast?
    action(data)
  }
}

