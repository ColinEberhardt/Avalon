//
//  UIView+BindingContext.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 08/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import ObjectiveC
import Foundation
import UIKit

private var bindingContentAssociationKey: UInt8 = 0


extension UIView {
  
  public var bindingContext: NSObject? {
    get {
      return objc_getAssociatedObject(self, &bindingContentAssociationKey) as? NSObject
    }
    set(newValue) {
      objc_setAssociatedObject(self, &bindingContentAssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
      
      if let viewModel = bindingContext {
        initiateBindingsForView(self, viewModel: viewModel, skipBindingContext: true)
      }
    }
  }
  
  // combines the bindings array with any bindings from the designer
  func bindingsForView(view: UIView) -> [Binding] {
    var b = [Binding]()
    if let viewBindings = view.bindings {
      b += viewBindings
    }
    if let viewBinding = view.binding {
      b += [viewBinding]
    }
    return b
  }
  
  func bindSourceToDestination(view: UIView, viewModel: NSObject, binding: Binding) {
    
    // dispose of any prior bindings
    binding.disposeAll()
    
    // create the new binding
    let kvoBinding = KVOBindingConnector(source: viewModel,
      destination: view, binding: binding)
    binding.addDisposable(kvoBinding)
  }
  
  
  func bindDestinationToSource(view: UIView, viewModel: NSObject, binding: Binding) {

    // unfortunately most UIKit controls are not KVO compliant, so we have to use target-action
    // in order to handle updates and relay the change back to the model
    if let slider = view as? UISlider {
      if let controlBinding = SliderConnector(source: viewModel, slider: slider, binding: binding) {
        binding.addDisposable(controlBinding)
      }
    } else if let segmentedControl = view as? UISegmentedControl {
      if let controlBinding = SegmentedControlConnector(source: viewModel, segmentedControl: segmentedControl, binding: binding) {
        binding.addDisposable(controlBinding)
      }
    } else if let textField = view as? UITextField {
      if let controlBinding = TextFieldControlConnector(source: viewModel, textField: textField, binding: binding) {
        binding.addDisposable(controlBinding)
      }
    } else {
      println("ERROR: destination view \(view) does not support two-way binding, with binding \(binding)");
    }
  }
  
  func contextBindingForView(view: UIView) -> Binding? {
    let allBindings = bindingsForView(view)
    let contextBindings = allBindings.filter({ $0.destinationProperty == "bindingContext" })
    if contextBindings.count > 0 {
      return contextBindings[0]
    } else {
      return nil
    }
  }
  
  func bindingContextForView(view: UIView) -> NSObject? {
    if let viewModel = view.bindingContext {
      return viewModel
    } else {
      if let superview = view.superview {
        return bindingContextForView(superview)
      } else {
        return nil
      }
    }
  }
  
  // initiates the bindings associated with the given view, for the supplied view model
  func initiateBindingsForView(view: UIView, viewModel: NSObject, skipBindingContext: Bool) {
    
    let contextBinding = contextBindingForView(view)
    
    if contextBinding != nil && !skipBindingContext {
      
      // bindings for the 'bindingContext' property should be evaluate aginst the
      // context for the parent element
      let parentViewModel = bindingContextForView(view.superview!)
      bindSourceToDestination(view, viewModel: parentViewModel!, binding: contextBinding!)
      
    } else {
      
      // obtain all the bindings that need to be initialised
      var allBindings = bindingsForView(view)
      if skipBindingContext {
        allBindings = allBindings.filter { $0.destinationProperty != "bindingContext" }
      }
      
      for binding in allBindings {
        bindSourceToDestination(view, viewModel: viewModel, binding: binding)
        if binding.mode == .TwoWay {
          bindDestinationToSource(view, viewModel: viewModel, binding: binding)
        }
      }
      
      // recursively apply bindings for subview
      for subview in view.subviews as [UIView] {
        initiateBindingsForView(subview, viewModel: viewModel, skipBindingContext: false)
      }
    }
  }
}