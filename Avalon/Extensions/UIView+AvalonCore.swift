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

extension UIView {
  
  public var bindingContext: NSObject? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.bindingContext) as? NSObject
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.bindingContext, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
      
      if let viewModel = bindingContext {
        initiateBindingsForView(self, viewModel: viewModel, skipBindingContext: true)
      }
    }
  }
  
  // combines the bindings array with any bindings from the designer
  func bindingsForBindableObject(view: Bindable) -> [Binding] {
    var b = [Binding]()
    if let viewBindings = view.bindings {
      b += viewBindings
    }
    if let viewBinding = Binding.fromBindable(view) {
      b += [viewBinding]
    }
    return b
  }
  
  func bindSourceToDestination<T: NSObject>(view: T, viewModel: NSObject, binding: Binding) {
    
    // dispose of any prior bindings
    binding.disposeAll()
    
    let nsObject = view as NSObject
    
    // create the new binding
    if let kvoBinding = KVOBindingConnector(source: viewModel, destination: view, binding: binding) {
      binding.addDisposable(kvoBinding)
    }
  }
  
  func bindDestinationToSource(view: UIView, viewModel: NSObject, binding: Binding) {

    // unfortunately most UIKit controls are not KVO compliant, so we have to use target-action
    // and a variety of ther techniques in order to handle updates and relay the change back to the model
    
    
    if binding.sourceProperty == "." {
      ErrorSink.instance.logEvent("ERROR: Two way binding does not support the dot syntax, with binding \(binding)")
      
    } else if let control = view as? UIControl {
      bindDestinationToSourceForControl(control, viewModel: viewModel, binding: binding)
      
    } else {
      
      // this is not a UIControl subclass, so try and bind using other mechanisms
      if let searchBar = view as? UISearchBar {
        if binding.destinationProperty == "text" {
          //TODO: add converter support & setter failure
          searchBar.searchBarDelegate.textChangedObserver = {
            (text: String) in
            NSObjectHelper.trySetValue(text, forKeyPath: binding.sourceProperty, forObject: viewModel)
            return
          }
        } else if binding.destinationProperty == "selectedScopeButtonIndex" {
          //TODO: add converter support & setter failure
          searchBar.searchBarDelegate.scopeButtonIndexChanged = {
            (index: Int) in
            NSObjectHelper.trySetValue(index, forKeyPath: binding.sourceProperty, forObject: viewModel)
            return
          }
        } else {
          ErrorSink.instance.logEvent("ERROR: view \(view) does not support two-way binding, with binding \(binding)")
        }
      } else {
        ErrorSink.instance.logEvent("ERROR: view \(view) does not support two-way binding, with binding \(binding)")
      }
    }
  }
  
  func bindDestinationToSourceForControl(control: UIControl, viewModel: NSObject, binding: Binding) {
    
    
    // UIControl subclasses all support target-action pattern so can be
    // bound in a generic fashion via UIControlBindingConnector
    let connectors: [(AnyClass, String, UIControlEvents, UIControl -> AnyObject)] = [
      (UISlider.self, "value", .ValueChanged, { control in (control as UISlider).value }),
      (UISegmentedControl.self, "selectedSegmentIndex", .ValueChanged, { control in (control as UISegmentedControl).selectedSegmentIndex }),
      (UISwitch.self, "on", .ValueChanged, { control in (control as UISwitch).on }),
      (UITextField.self, "text", .EditingChanged, { control in (control as UITextField).text }),
      (UIStepper.self, "value", .ValueChanged, { control in (control as UIStepper).value }),
      (UIDatePicker.self, "date", .ValueChanged, { control in (control as UIDatePicker).date }),
    ]
    
    for connector in connectors {
      if control.dynamicType === connector.0 {
        
        if binding.destinationProperty != connector.1 {
          ErrorSink.instance.logEvent("ERROR: view \(control) does not support two-way binding, with binding \(binding)")
        } else {
          let connector = UIControlBindingConnector(source: viewModel, destination: control, valueExtractor: { connector.3(control) }, binding: binding, events: connector.2)
          binding.addDisposable(connector)
          return
        }
      }
    }
    ErrorSink.instance.logEvent("ERROR: view \(control) does not support two-way binding, with binding \(binding)")
  }
  
  func contextBindingForView(view: UIView) -> Binding? {
    let allBindings = bindingsForBindableObject(view)
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
    
    // TODO: Unit tests and check this works with bindingContext bindings
    // bind the geature recognizers
    if let gestureRecognizers = self.gestureRecognizers {
      for maybeGestureRecognizer in gestureRecognizers {
        if let gestureRecognizer = maybeGestureRecognizer as? UIGestureRecognizer {
          for binding in bindingsForBindableObject(gestureRecognizer) {
            bindSourceToDestination(gestureRecognizer, viewModel: viewModel, binding: binding)
          }
        }
      }
    }
    
    // does this veiw have a binding for the bindingContextProperty?
    let contextBinding = contextBindingForView(view)
    
    if contextBinding != nil && !skipBindingContext {
      
      // bindings for the 'bindingContext' property should be evaluate aginst the
      // context for the parent element
      let parentViewModel = bindingContextForView(view.superview!)
      bindSourceToDestination(view, viewModel: parentViewModel!, binding: contextBinding!)
      
    } else {
      
      // obtain all the bindings that need to be initialised
      var allBindings = bindingsForBindableObject(view)
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