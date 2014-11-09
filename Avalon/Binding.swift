//
//  Binding.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 04/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

@objc public class Binding {
  var destinationProperty = ""
  var sourceProperty = ""
  var converter: ValueConverter?
  var mode = BindingMode.OneWay
  
  var disposable: Disposable?
  
  init(source: String, destination: String) {
    self.destinationProperty = destination
    self.sourceProperty = source
  }
  
  init(source: String, destination: String, mode: BindingMode) {
    self.destinationProperty = destination
    self.sourceProperty = source
    self.mode = mode
  }
  
  init(source: String, destination: String, converter: ValueConverter) {
    self.destinationProperty = destination
    self.sourceProperty = source
    self.converter = converter
  }
  
  class func fromBindable(bindable: Bindable) -> Binding? {
    if bindable.source != "" && bindable.destination != "" {
      
      // create a binding
      let binding = Binding(source: bindable.source, destination: bindable.destination)
      
      // add a converter
      if bindable.converter != "" {
        let converterClass = NSClassFromString(bindable.converter) as NSObject.Type
        binding.converter = converterClass() as ValueConverter
      }
      
      if bindable.mode == "TwoWay" {
        binding.mode = .TwoWay
      }
      
      return binding
    } else {
      return nil
    }
  }
}