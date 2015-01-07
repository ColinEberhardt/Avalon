//
//  AvalonTests.swift
//  AvalonTests
//
//  Created by Colin Eberhardt on 09/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

class PersonViewModel: NSObject {
  dynamic var name = "Bob"
  let surname = "Eggbert"
  let age = 22
  var height = 0.3
  dynamic var isFemale = true
  dynamic var address = AddressViewModel()
  var badProperty = NonNSObject()
}

class AddressViewModel: NSObject {
  dynamic var city = "Newcastle"
}

class NonNSObject {
  var foo = "bar"
}

// System / integration level tests for the framework
class AvalonCoreTests: XCTestCase {
  
  func test_bindingContext_isAppliedToViewHierarchy() {
    
    // create a view and a bound label
    let view = UIView()
    let label = UILabel()
    label.bindings = [Binding(source: "name", destination: "text")]
    view.addSubview(label)
    
    // add a view model
    view.bindingContext = PersonViewModel()
    
    XCTAssertEqual(label.text!, "Bob")
  }
  
  
  func test_bindingContext_isAppliedToView() {
    
    // create a view and a bound label
    let label = UILabel()
    label.bindings = [Binding(source: "name", destination: "text")]
    
    // add a view model
    label.bindingContext = PersonViewModel()
    
    XCTAssertEqual(label.text!, "Bob")
  }
  
  
  func test_bindingContext_supportsBindingsAcrossTheHierarchy() {
    
    // create a view and a bound label
    let view = UILabel()
    view.bindings = [Binding(source: "name", destination: "text")]
    let label = UILabel()
    label.bindings = [Binding(source: "name", destination: "text")]
    view.addSubview(label)
    
    // create two new vms
    let viewModelOne = PersonViewModel()
    let viewModelTwo = PersonViewModel()
    viewModelTwo.name = "Frank"
    
    // bind each vm to a different part of the view
    view.bindingContext = viewModelOne
    XCTAssertEqual(label.text!, "Bob")
    XCTAssertEqual(view.text!, "Bob")
    
    label.bindingContext = viewModelTwo
    XCTAssertEqual(view.text!, "Bob")
    XCTAssertEqual(label.text!, "Frank")
  }

  
  func test_bindingContext_canBeBound() {
    
    // create a view and a bound label
    let view = UILabel()
    view.bindings = [Binding(source: "name", destination: "text")]
    let label = UILabel()
    label.bindings = [Binding(source: "address", destination: "bindingContext"),
      Binding(source: "city", destination: "text")]
    view.addSubview(label)
    
    // bind the view model
    view.bindingContext = PersonViewModel()
    XCTAssertEqual(view.text!, "Bob")
    XCTAssertEqual(label.text!, "Newcastle")
    
    // update the view model
    let newViewModel = PersonViewModel()
    newViewModel.name = "Frank"
    newViewModel.address.city = "Jamaica"
    
    view.bindingContext = newViewModel
    XCTAssertEqual(view.text!, "Frank")
    XCTAssertEqual(label.text!, "Jamaica")
  }
  
  func test_bindingContext_canBeChanged() {
    
    // create a bound label
    let label = UILabel()
    label.bindings = [Binding(source: "surname", destination: "text")]
    
    // bind twice
    label.bindingContext = PersonViewModel()
    label.bindingContext = PersonViewModel()
    
    // verify state
    XCTAssertEqual(label.text!, "Eggbert")
  }
  
  func test_bindingContext_inherittedByNewlyAddedViews() {
    
    // create a bound label
    let label = UILabel()
    label.bindings = [Binding(source: "surname", destination: "text")]
    
    // create a view with a binding
    let parentView = UIView()
    parentView.bindingContext = PersonViewModel()
    
    // add the label and ensure its binding is now actioned
    parentView.addSubview(label)
    
    // verify state
    XCTAssertEqual(label.text!, "Eggbert")
  }
  
  func test_binding_multipleProperties() {
    
    // create a bound label
    let label = UILabel()
    label.bindings = [Binding(source: "name", destination: "text"),
      Binding(source: "isFemale", destination: "hidden")]
    
    // add a view model
    let viewModel = PersonViewModel()
    label.bindingContext = viewModel
    
    // state
    XCTAssertEqual(label.text!, "Bob")
    XCTAssertEqual(label.hidden, true)
    
  }
  
  func test_binding_twoWayToSlider() {
    
    // create a bound slider
    let slider = UISlider()
    slider.bindings = [Binding(source: "height", destination: "value", mode: .TwoWay)]
    
    // add a view model
    let viewModel = PersonViewModel()
    slider.bindingContext = viewModel
    
    // check initial state
    XCTAssertEqual(slider.value, Float(0.3))
    
    // update the slider
    slider.value = Float(0.5)
    
    // fire the action
    fireUpdateForControlBinding(slider)
    
    // check initial state
    XCTAssertEqual(viewModel.height, 0.5)
  }
  
  func test_binding_twoWayDoesNotSupportDotSyntaxForSource() {
    AssertLogsError("ERROR: Two way binding does not support the dot syntax") {
      // create a bound slider
      let slider = UISlider()
      slider.bindings = [Binding(source: ".", destination: "value", mode: .TwoWay)]
      
      // add a view model
      let viewModel = 45.0
      slider.bindingContext = viewModel
    }
  }
  
  // locates the ControlBinding instance and invokes its update function. This
  // should be possible via sendActionsForControlEvents, but for some reaosn
  // that is not working
  private func fireUpdateForControlBinding(control: UIControl) {
    let binding = control.bindings![0]
    let cb = binding.disposables.filter({ ($0 as? UIControlBindingConnector) != nil })
    let controlBinding = cb[0] as UIControlBindingConnector
    controlBinding.valueChanged()
  }
  
  
  class AgeToString: NSValueTransformer {
    override class func load() {
      NSValueTransformer.setValueTransformer(AgeToString(), forName: "AgeToString")
    }
    override func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
      let age: Int = sourceValue as Int
      return String(age)
    }
  }
  
  
  func test_binding_supportsValueConversion() {
    
    // create a bound label
    let label = UILabel()
    label.bindings = [Binding(source: "age", destination: "text", transformer: AgeToString())]
    
    // add a view model
    let viewModel = PersonViewModel()
    label.bindingContext = viewModel
    
    // state
    XCTAssertEqual(label.text!, "22")
  }

}
