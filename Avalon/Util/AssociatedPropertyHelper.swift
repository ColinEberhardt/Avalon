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


// creates an associated property getter, lazy initializing the property value with the given factory
func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, factory: ()->T?) -> T? {
  var associatedProperty = objc_getAssociatedObject(host, key) as? T
  
  if associatedProperty == nil {
    associatedProperty = factory()
    objc_setAssociatedObject(host, key, associatedProperty, UInt(OBJC_ASSOCIATION_RETAIN))
  }
  return associatedProperty
}

// gets the value for an associated property. If the value is currently nil, the supplied default value is returned
func getAssociatedProperty<T>(object: AnyObject!, key: UnsafePointer<Void>, defaultValue: T) -> T {
  let value = objc_getAssociatedObject(object, key) as T?
  if let unwrappedValue = value {
    return unwrappedValue
  } else {
    return defaultValue
  }
}