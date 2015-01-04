//
//  CustomOperatrs.swift
//  Avalon
//
//  Created by Colin Eberhardt on 03/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

infix operator >| { associativity left }

infix operator >>| { associativity left }

infix operator |<< { associativity left }

infix operator |<>| {}

public func >| (source: String, destination: String) -> Binding {
  return Binding(source: source, destination: destination, mode: .OneWay)
}

public func |<>| (source: String, destination: String) -> Binding {
  return Binding(source: source, destination: destination, mode: .TwoWay)
}

public func >>| (source: String, transformer: String) -> PartialBinding {
  return PartialBinding(source: source, transformer: transformer, mode: .OneWay)
}

public func >>| (partial: PartialBinding, destination: String) -> Binding {
  let transformer = NSValueTransformer(forName: partial.transformer)
  if transformer == nil {
    ErrorSink.instance.logEvent("ERROR: The transformer \(partial.transformer) was not found, did you register it via NSValueTransformer.setValueTransformerForName or NSVaueTransformer.setValueTransformer ?")
  }
  return Binding(source: partial.source, destination: destination, transformer: transformer, mode: partial.mode)
}

public func |<< (source: String, transformer: String) -> PartialBinding {
  return PartialBinding(source: source, transformer: transformer, mode: .TwoWay)
}

// a structure that is used to support the creation of bindings with transformers
// e.g. "foo" >>| "ValueTransformerName" >>| "bar"
public struct PartialBinding {
  let source: String
  let transformer: String
  let mode: BindingMode
}
