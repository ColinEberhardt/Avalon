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

/// Provides a mechanism for logging errors and warnings.
public class ErrorSink {
  
  private var sink: Sink = ErrorSink.printlnSink
  
  public init() {
  }
  
  /// The singleton sink that Avalon uses
  public class var instance: ErrorSink {
    return sinkInstance
  }
  
  func logEvent(event: String) {
    sink(event)
  }
  
  /// Sets the new sink that receives error / warning messages.
  public func setSink(sink: Sink) {
    self.sink = sink
  }
  
  private class func printlnSink(event: String) {
    println(event)
  }
}