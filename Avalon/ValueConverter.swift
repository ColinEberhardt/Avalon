//
//  ValueConverter.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 05/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation



/// Provides a mechanism for transforming values that are applied via bindings.
@objc public class ValueConverter: NSObject {
  // subclasses NSObject and annotated @objc so that we can generate the
  // class instances from strings

  public func convert(sourceValue: AnyObject?, binding: Binding, viewModel: AnyObject) -> AnyObject? {
    return self.convert(sourceValue)
  }
  
  public func convert(sourceValue: AnyObject?) -> AnyObject? {
    ErrorSink.instance.logEvent("ERROR: The 'convert' method of a value converter was not implemented")
    return nil
  }
  
  public func convertBack(sourceValue: AnyObject?, binding: Binding, viewModel: AnyObject) -> AnyObject? {
    return self.convertBack(sourceValue)
  }
  
  public func convertBack(sourceValue: AnyObject?) -> AnyObject? {
    ErrorSink.instance.logEvent("ERROR: The 'convertBack' method of a value converter was not implemented")
    return nil
  }
}