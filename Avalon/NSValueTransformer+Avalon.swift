//
//  NSValueTransformer+Avalon.swift
//  Avalon
//
//  Created by Colin Eberhardt on 03/01/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import Foundation

extension NSValueTransformer {
  public class func registerTransformer<U: AnyObject, T: AnyObject>(name: String, closure: U -> T) {
    NSValueTransformer.setValueTransformer(ClosureValueTransformer(closure), forName: name)
  }
}

class ClosureValueTransformer<U: AnyObject, T: AnyObject>: NSValueTransformer {
  
  let closure: U -> T
  
  init(closure: U -> T) {
    self.closure = closure
  }
  override func transformedValue(value: AnyObject?) -> AnyObject? {
    if let valueAsU = value as? U {
      return self.closure(valueAsU)
    }
    return nil
  }
}