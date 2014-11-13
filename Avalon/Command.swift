//
//  Command.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 07/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

@objc public protocol Command {
  func execute()
}

@objc public class ClosureCommand: Command {
  private let action: () -> ()
  
  public init(action: () -> ()) {
    self.action = action
  }
  
  public func execute() {
    action()
  }
}