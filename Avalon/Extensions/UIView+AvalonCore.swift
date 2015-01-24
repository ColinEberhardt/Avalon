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

// a function that is invoked when the value of some property changes. The function
// argument provides the new value. This is typically used as a way of implementing TwoWay
// binding, where controls expose propertes of this type in order to inform the
// core binding engine that a value has changed.
typealias ValueChangedNotification = (AnyObject) -> ()

extension UIView {
  
  // MARK:- Public API
  
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
  
  // Obtains the binding context for this view, either as a result of the binding
  // context having been set directly, or via inheritence from a parent view
  public func getInheritedBindingContext() -> NSObject? {
    if let viewModel = self.bindingContext {
      return viewModel
    } else {
      if let superview = self.superview {
        return superview.getInheritedBindingContext()
      } else {
        return nil
      }
    }
  }

  /// In order to aid debugging, this function dumps the view hierarchy together
  /// with any bindings that are present
  public func dumpBindings() {
    dumpBindingsForView(self, indent: 0)
  }
  
  // MARK:- Private API
  
  func dumpBindingsForView(view: UIView, indent: Int) {
    for var i=0;i<indent;i++ {
      print("   ")
    }
    println(view)
    for binding in bindingsForBindableObject(view) {
      for var i=0;i<indent;i++ {
        print("   ")
      }
      println("  ##  \(binding)")
    }
    
    for subview in view.subviews as [UIView] {
      dumpBindingsForView(subview, indent: (indent+1))
    }
  }
  
  // combines the bindings array with any bindings from the designer
  func bindingsForBindableObject(view: Bindable) -> [Binding] {
    var b = [Binding]()
    if let viewBindings = view.bindings {
      b += viewBindings
    }
    if let viewBinding = view.bindingFromBindable {
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
    // and a variety of other techniques in order to handle updates and relay the change back to the model
    
    if binding.sourceProperty == "." {
      ErrorSink.instance.logEvent("ERROR: Two way binding does not support the dot syntax, with binding \(binding)")
    } else if let control = view as? UIControl {
      bindDestinationToSourceForControl(control, viewModel: viewModel, binding: binding)
    } else {
      bindDestinationToSourceForUIView(view, viewModel: viewModel, binding: binding)
    }
  }
  
  // UIView subclasses all use delegate methods to inform of updates. The Avalon extensions
  // to these controls add delegate implementations that have 'observer' functions associated
  // with them. This function adds handlers for the required observer function, with the
  // handler updating the respective source property via KVC
  func bindDestinationToSourceForUIView(view: UIView, viewModel: NSObject, binding: Binding) {
    
    let connectors: [(AnyClass, String, (ValueChangedNotification)->() )] = [
      (UISearchBar.self, "text", { observer in (view as UISearchBar).searchBarDelegate.textChangedObserver = observer }),
      (UISearchBar.self, "selectedScopeButtonIndex", { observer in (view as UISearchBar).searchBarDelegate.scopeButtonIndexChanged = observer }),
      (UIPickerView.self, "selectedItemIndex", { observer in (view as UIPickerView).itemsController.selectionChangedObserver = observer }),
      (UITextView.self, "text", { observer in (view as UITextView).textViewDelegate.textChangedObserver = observer }),
      (UITableView.self, "selectedItemIndex", { observer in (view as UITableView).itemsController.selectionChangedObserver = observer }),
    ]
    
    for connector in connectors {
      if view.dynamicType === connector.0 && binding.destinationProperty == connector.1 {
        connector.2(createValueChangeObserver(binding, viewModel: viewModel, view: view))
        return
      }
    }
    
    ErrorSink.instance.logEvent("ERROR: view \(view) does not support two-way binding, with binding \(binding)")
  }
  
  
  // Creates a function that updates the binding source
  func createValueChangeObserver(binding: Binding, viewModel: NSObject, view: UIView) -> ValueChangedNotification {
    return {
      (value: AnyObject) in
      setValueFromBinding(value: value, binding: binding, source: view, destination: viewModel, destinationProperty: binding.sourceProperty, binding.transformer?.reverseTransformedValue)
      return
    }
  }
  
  // UIControl subclasses all support target-action pattern so can be
  // bound in a generic fashion via UIControlBindingConnector
  func bindDestinationToSourceForControl(control: UIControl, viewModel: NSObject, binding: Binding) {
    
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
        
        // unfortunately we have to special-case the logic for UITextField here. Depending
        // on the bindingUpdateMode, the target action needs to either subscribe
        // to EditingChanged or EditingDidEnd events
        var controlEvents = connector.2
        if let textField = control as? UITextField {
          controlEvents = textField.bindingUpdateMode == .OnChange
              ? .EditingChanged : .EditingDidEnd
        }
        
        if binding.destinationProperty != connector.1 {
          ErrorSink.instance.logEvent("ERROR: view \(control) does not support two-way binding, with binding \(binding)")
        } else {
          let connector = UIControlBindingConnector(source: viewModel, destination: control, valueExtractor: { connector.3(control) }, binding: binding, events: controlEvents)
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
      let parentViewModel = view.superview!.getInheritedBindingContext()
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

  
  func override_didMoveToSuperview() {
    // when an view is added to the view hierarchy, determine the inherited bindingContext
    // and use this in order to initiate the binding associated with this view and its children
    let viewModel = self.getInheritedBindingContext();
    if let viewModel = viewModel {
      initiateBindingsForView(self, viewModel: viewModel, skipBindingContext: true)
    }
    
    self.override_didMoveToSuperview()
  }
}