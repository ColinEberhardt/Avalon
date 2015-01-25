//
//  ValueSetter.swift
//  Avalon
//
//  Created by Colin Eberhardt on 29/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

typealias ConversionFunction = (AnyObject?) -> AnyObject?

// applies a new value taken from the source, to the destination, performing
// any value conversion that might be required.
func setValueFromBinding(var #value: AnyObject?, #binding: Binding, #source: NSObject, #destination: NSObject, #destinationProperty: String, #converter: ConversionFunction?) -> String? {
  
  // perform any required value conversion
  if let valueConverter = converter {
    value = valueConverter(value)
  }
  
  // set the value, handling any errors
  let maybeFailureMessage = destination.trySetValue(value, forKeyPath: destinationProperty)
  if let failureMessage = maybeFailureMessage {
    ErrorSink.instance.logEvent("ERROR: Unable to set value \(value) on destination \(destination) with binding \(binding)")
  }
  return maybeFailureMessage
}
