//
//  AssociatedPropertyHelper.swift
//  Avalon
//
//  Created by Colin Eberhardt on 07/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// creates an associated property getter, lazy initializing the property value with the given factory
func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, factory: ()->T) -> T {
  var associatedProperty = objc_getAssociatedObject(host, key) as? T
  
  if associatedProperty == nil {
    associatedProperty = factory()
    objc_setAssociatedObject(host, key, associatedProperty, UInt(OBJC_ASSOCIATION_RETAIN))
  }
  return associatedProperty!
}
