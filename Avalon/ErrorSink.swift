//
//  AvalonErrorSink.swift
//  Avalon
//
//  Created by Colin Eberhardt on 17/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

private let sinkInstance = ErrorSink()

public typealias Sink = (String)->()

public class ErrorSink {
  
  private var sink: Sink = ErrorSink.printlnSink
  
  public init() {
    
  }
  
  public class var instance: ErrorSink {
    return sinkInstance
  }
  
  public func logEvent(event: String) {
    sink(event)
  }
  
  public func setSink(sink: Sink) {
    self.sink = sink
  }
  
  private class func printlnSink(event: String) {
    println(event)
  }
}