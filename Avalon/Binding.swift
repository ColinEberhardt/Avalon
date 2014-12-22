//
//  Binding.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 04/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

/// Defines a binding between a view model property and a corresonding property on a UI control.
///
/// The view model is considered the source and the UI control is the destination. The source
/// for a binding is determined from the value of the bindingContext on the UIControl that this
/// binding is associated with.
@objc public class Binding: Printable {
  
  /// The name of the property on this UI control that will be the destination for the binding.
  public var destinationProperty = ""
  
  /// The name of the property on the source view model (i.e. the binding context), that
  /// will be used by the binding.
  public var sourceProperty = ""
  
  /// An (optional) converter for this binding.
  public var converter: ValueConverter?
  
  /// The mode of this binding
  public var mode = BindingMode.OneWay
  
  // an array of items that should be disposed when this binding is
  // detached from a UI control.
  public var disposables = [Disposable]()
  
  public init(source: String, destination: String) {
    self.destinationProperty = destination
    self.sourceProperty = source
  }
  
  public init(source: String, destination: String, mode: BindingMode) {
    self.destinationProperty = destination
    self.sourceProperty = source
    self.mode = mode
  }
  
  public init(source: String, destination: String, converter: ValueConverter) {
    self.destinationProperty = destination
    self.sourceProperty = source
    self.converter = converter
  }
  
  func addDisposable(disposable: Disposable) {
    disposables.append(disposable)
  }
  
  func disposeAll() {
    for disposable in disposables {
      disposable.dispose()
    }
    disposables.removeAll(keepCapacity: false)
  }
  
  public var description: String {
    return "<Avalon.Binding sourceProperty = \(sourceProperty); destinationProperty = \(destinationProperty); mode = \(mode); converter = \(converter); disposables = \(disposables.count)>"
  }
  
  // takes the publicly exposed binding components and constructs
  // a binding instance
  class func fromBindable(bindable: Bindable) -> Binding? {
    if bindable.source != "" && bindable.destination != "" {
      
      // create a binding
      let binding = Binding(source: bindable.source, destination: bindable.destination)
      
      // add a converter
      if bindable.converter != "" {
        if let converterClass = NSClassFromString(bindable.converter) as? NSObject.Type {
          binding.converter = converterClass() as? ValueConverter
        } else {
          ErrorSink.instance.logEvent("ERROR: A converter of class \(bindable.converter) could not be constructed.")
        }
      }
      
      if bindable.mode == "TwoWay" {
        binding.mode = .TwoWay
      } else if bindable.mode == "OneWay" {
        binding.mode = .OneWay
      } else if bindable.mode != "" {
        ErrorSink.instance.logEvent("ERROR: binding mode can only have values of OneWay or TwoWay, the value \(bindable.mode) is not permitted.")
      }
      
      return binding
    } else {
      if bindable.source != "" || bindable.destination != "" ||
        bindable.converter != "" || bindable.mode != "" {
        ErrorSink.instance.logEvent("ERROR: bindings must have both a source and destination property.")
      }
      return nil
    }
  }

  
}