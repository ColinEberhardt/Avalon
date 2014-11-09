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
private var bindingAssociationKey: UInt8 = 1

extension UIView {
  
  var bindingContext: AnyObject? {
    get {
      return objc_getAssociatedObject(self, &bindingContentAssociationKey)
    }
    set(newValue) {
      objc_setAssociatedObject(self, &bindingContentAssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
      
      if let viewModel = bindingContext {
        initiateBindingsForView(self, viewModel: viewModel, skipBindingContext: true)
      }
    }
  }
  
  var bindings: [Binding]? {
    get {
      return objc_getAssociatedObject(self, &bindingAssociationKey) as? [Binding]
    }
    set(newValue) {
      objc_setAssociatedObject(self, &bindingAssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
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
  
  func bindSourceToDestination(view: UIView, viewModel: AnyObject, binding: Binding) {
    
    // dispose of any prior bindings
    if let disposable = binding.disposable {
      disposable.dispose()
    }
    
    // create the new binding
    let kvoBinding = KVOBinding(source: viewModel as NSObject, sourceKeyPath: binding.sourceProperty,
      destination: view, destinationKeyPath: binding.destinationProperty, converter: binding.converter)
    binding.disposable = kvoBinding
  }
  
  func updateOnValueChanged(control: UIControl, viewModel: AnyObject,
                    binding: Binding, valueProperty: String, valueExtractor: ()->(AnyObject)) {
  /*  if binding.destinationProperty == valueProperty {
      control
        .rac_signalForControlEvents(UIControlEvents.ValueChanged)
        .map {
          (next) -> AnyObject! in
          return valueExtractor()
        }
        .setKeyPath(binding.sourceProperty, onObject: viewModel as NSObject)
    } else {
      println("ERROR: destination property does not support two-way binding");
    }*/
  }
  
  func bindDestinationToSource(view: UIView, viewModel: AnyObject, binding: Binding) {
    
    // unfortunately most UIKit controls are not KVO compliant, so we have to use taregt-action
    // in order to handle updates and relay the change back to the model
    
    
    // TODO: disposal of bindings
  /*  if let textField = view as? UITextField {
      if binding.destinationProperty == "text" {
        textField
          .rac_textSignal()
          .setKeyPath(binding.sourceProperty, onObject: viewModel as NSObject)
      } else {
        println("ERROR: destination property does not support two-way binding");
      }
    } else if let slider = view as? UISlider {
      updateOnValueChanged(slider, viewModel: viewModel, binding: binding,
        valueProperty: "value", valueExtractor: { () in slider.value })
    } else if let segmentedControl = view as? UISegmentedControl {
      updateOnValueChanged(segmentedControl, viewModel: viewModel, binding: binding,
        valueProperty: "selectedSegmentIndex", valueExtractor: { () in segmentedControl.selectedSegmentIndex })
    } else {
      println("ERROR: destination view does not support two-way binding");
    }*/
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
  
  func bindingContextForView(view: UIView) -> AnyObject? {
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
  func initiateBindingsForView(view: UIView, viewModel: AnyObject, skipBindingContext: Bool) {
    
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