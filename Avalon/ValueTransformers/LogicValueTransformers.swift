//
//  LogicValueTransformers.swift
//  Avalon
//
//  Created by Colin Eberhardt on 08/01/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import Foundation

public class NotValueTransformer: NSValueTransformer {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(NotValueTransformer(), forName:"Not")
  }
  
  override public func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    if let boolValue = sourceValue as? Bool {
      return !boolValue
    } else {
      ErrorSink.instance.logEvent("ERROR: the value \(sourceValue) supplied to the value transformer NotValueTransformer was not a boolean value")
      return nil
    }
  }
  
  override public func reverseTransformedValue(sourceValue: AnyObject?) -> AnyObject? {
    if let boolValue = sourceValue as? Bool {
      return !boolValue
    }
    return nil
  }
}