//
//  NSValueTransformer+Avalon.swift
//  Avalon
//
//  Created by Colin Eberhardt on 03/01/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import Foundation

extension NSValueTransformer {
  
  /// Creates and registers a value transformer that uses the supplied function to perform
  /// the value transformation.
  public class func setValueTransformerForName(name: String, transformFunction: AnyObject? -> AnyObject?) {
    NSValueTransformer.setValueTransformer(ClosureValueTransformer(transformFunction), forName: name)
  }
}

class ClosureValueTransformer: NSValueTransformer {
  
  let closure: AnyObject? -> AnyObject?
  
  init(closure: AnyObject? -> AnyObject?) {
    self.closure = closure
  }
  
  override func transformedValue(value: AnyObject?) -> AnyObject? {
    return closure(value)
  }
}