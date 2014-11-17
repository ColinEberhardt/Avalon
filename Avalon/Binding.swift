//
//  Binding.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 04/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

@objc public class Binding: Printable {
  public var destinationProperty = ""
  public var sourceProperty = ""
  public var converter: ValueConverter?
  public var mode = BindingMode.OneWay
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
    
    return "<Avalon.Binding sourceProperty = \(sourceProperty); destinationProperty = \(destinationProperty); mode = \(mode); converter = \(converter)"
  }
  
  // take the publicly exposed binding components and construct
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
      return nil
    }
  }

  
}