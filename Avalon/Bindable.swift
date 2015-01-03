//
//  Bindable.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 05/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

/// A protocol that defines one or more bindings for a UI control.
///
/// A binding may be defined via the following four properties:
///  * source
///  * destination
///  * transformer
///  * mode
///
/// These properties are intended to be used within Storyboards / interface builder, where
/// they are present in the Attributes Inspector.
///
/// The bindings array is intended for use in code.
@objc public protocol Bindable {
  
  /// The name of the property on the source object (i.e. the binding context), that 
  /// will be used by the binding.
  var source: String { get set }
  
  /// The name of the property on this UI control that will be the destination for the binding.
  var destination: String { get set }

  /// The name of an (optional) value transformer for this binding.
  var transformer: String { get set }

  /// The mode of this binding, defaults to one-way if the string is anything other than 'TwoWay'
  var mode: String { get set }
  
  /// The array of bindings associated with this control
  var bindings: [Binding]? { get set }
  
  /// Constructs a Binding instance from the source, destination, transformer and mode properties
  var bindingFromBindable: Binding? { get }
}
