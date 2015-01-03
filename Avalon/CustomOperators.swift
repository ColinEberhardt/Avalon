//
//  CustomOperatrs.swift
//  Avalon
//
//  Created by Colin Eberhardt on 03/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

infix operator >| { associativity left }

infix operator |< { associativity left }

infix operator |<>| {}

public func >| (source: String, destination: String) -> Binding {
  return Binding(source: source, destination: destination, mode: .OneWay)
}

public func |<>| (source: String, destination: String) -> Binding {
  return Binding(source: source, destination: destination, mode: .TwoWay)
}

public func >| (source: String, transformer: NSValueTransformer) -> PartialBinding {
  return PartialBinding(source: source, transformer: transformer, mode: .OneWay)
}

public func >| (partial: PartialBinding, destination: String) -> Binding {
  return Binding(source: partial.source, destination: destination, transformer: partial.transformer, mode: partial.mode)
}

public func |< (source: String, transformer: NSValueTransformer) -> PartialBinding {
  return PartialBinding(source: source, transformer: transformer, mode: .TwoWay)
}

// a structure that is used to support the creation of bindings with transformers
// e.g. "foo" >| ValueTransformer() >| "bar"
public struct PartialBinding {
  let source: String
  let transformer: NSValueTransformer
  let mode: BindingMode
}
