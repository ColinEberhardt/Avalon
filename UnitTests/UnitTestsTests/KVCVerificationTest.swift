//
//  KVCVerificationTest.swift
//  Avalon
//
//  Created by Colin Eberhardt on 12/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon

// this test case is partly an exploration of KVC, to see how
// setValue:forKey: handles invalid inputs, and to test whether KVCVerification generates
// useful warnings in these cases
class KVCVerificationTest: XCTestCase {
  
  func test_stringProperty() {
    let textField = UITextField()
    textField.text = "fish"
    
    textField.setValue(nil, forKey: "text")
    XCTAssertEqual("", textField.text)
    XCTAssertTrue(KVCVerification.verifyCanSetVale(nil, propertyPath: "text", destination: textField) == nil)
    
    textField.setValue("foo", forKey: "text")
    XCTAssertEqual("foo", textField.text)
    XCTAssertTrue(KVCVerification.verifyCanSetVale("foo", propertyPath: "text", destination: textField) == nil)
    
    textField.setValue(NSString(UTF8String: "bar"), forKey: "text")
    XCTAssertEqual("bar", textField.text)
    XCTAssertTrue(KVCVerification.verifyCanSetVale(NSString(UTF8String: "bar"), propertyPath: "text", destination: textField) == nil)
    
    // this will throw an exception
    // label.setValue(45, forKey: "text")
    
    // should fail our verification
    XCTAssertFalse(KVCVerification.verifyCanSetVale(24, propertyPath: "text", destination: textField) == nil)
    
    let label = UILabel()
    
    label.setValue("foo", forKey: "text")
    XCTAssertTrue(KVCVerification.verifyCanSetVale("foo", propertyPath: "text", destination: label) == nil)
    
    label.setValue(NSString(UTF8String: "foo"), forKey: "text")
    XCTAssertTrue(KVCVerification.verifyCanSetVale(NSString(UTF8String: "foo"), propertyPath: "text", destination: label) == nil)

  }
  
  func test_floatProperty() {
    let slider = UISlider()
    slider.maximumValue = 100
    
    // verify you can use doubles
    slider.setValue(Double(42.0), forKey: "value")
    XCTAssertEqual(Float(42), slider.value)
    XCTAssertTrue(KVCVerification.verifyCanSetVale(Double(42.0), propertyPath: "value", destination: slider) == nil)
    
    // verify you can use integers
    slider.setValue(Int(45), forKey: "value")
    XCTAssertEqual(Float(45), slider.value)
    XCTAssertTrue(KVCVerification.verifyCanSetVale(Int(45), propertyPath: "value", destination: slider) == nil)
    
    // verify you can use floats
    slider.setValue(Float(66), forKey: "value")
    XCTAssertEqual(Float(66), slider.value)
    XCTAssertTrue(KVCVerification.verifyCanSetVale(Float(66), propertyPath: "value", destination: slider) == nil)
    
    // verify you can use NSNumber
    slider.setValue(NSNumber(double: 48), forKey: "value")
    XCTAssertEqual(NSNumber(double: 48), slider.value)
    XCTAssertTrue(KVCVerification.verifyCanSetVale(NSNumber(double: 48), propertyPath: "value", destination: slider) == nil)
    
    // KVC allows you to attempt to set a float property with a string
    slider.setValue("string", forKey: "value")
    // this resets the slider value to a default
    XCTAssertEqual(Float(0.0), slider.value)
    
    // this fails our verification
    XCTAssertFalse(KVCVerification.verifyCanSetVale("string", propertyPath: "value", destination: slider) == nil)
  }
  
  func test_intProperty() {
    
    let segmentedControl = UISegmentedControl()
    segmentedControl.insertSegmentWithTitle("one", atIndex: 0, animated: false)
    segmentedControl.insertSegmentWithTitle("two", atIndex: 0, animated: false)
    segmentedControl.insertSegmentWithTitle("three", atIndex: 0, animated: false)
    segmentedControl.selectedSegmentIndex = 0
    
    // verify you can use int
    segmentedControl.setValue(Int(2), forKey: "selectedSegmentIndex")
    XCTAssertTrue(KVCVerification.verifyCanSetVale(Int(2), propertyPath: "selectedSegmentIndex", destination: segmentedControl) == nil)
    XCTAssertEqual(2, segmentedControl.selectedSegmentIndex)
    
    // verify you can use float
    segmentedControl.setValue(Float(1.0), forKey: "selectedSegmentIndex")
    XCTAssertTrue(KVCVerification.verifyCanSetVale(Float(1.0), propertyPath: "selectedSegmentIndex", destination: segmentedControl) == nil)
    XCTAssertEqual(1, segmentedControl.selectedSegmentIndex)
    
    // verify you cannot use string
    segmentedControl.setValue("foo", forKey: "selectedSegmentIndex")
    XCTAssertEqual(0, segmentedControl.selectedSegmentIndex)
    XCTAssertFalse(KVCVerification.verifyCanSetVale("foo", propertyPath: "selectedSegmentIndex", destination: segmentedControl) == nil)
    
  }
  
  func test_colourProperty() {
    let textField = UITextField()
    textField.textColor = UIColor.redColor()
    
    // check that UIColor is OK
    textField.setValue(UIColor.greenColor(), forKey: "textColor")
    XCTAssertEqual(UIColor.greenColor(), textField.textColor)
    XCTAssertTrue(KVCVerification.verifyCanSetVale(UIColor.greenColor(), propertyPath: "textColor", destination: textField) == nil)
    
    // you can actually set the property to a string value
    textField.setValue("fish", forKey: "textColor")
    XCTAssertEqual("fish", textField.textColor)
    
    // but we should warn about this
    XCTAssertFalse(KVCVerification.verifyCanSetVale("fish", propertyPath: "textColor", destination: textField) == nil)
  }
  
  func failing_test_booleanProperty() {
    let textField = UITextField()
    
    // TODO: Unfortunately the 'hidden' property of UIView is not a real property. Instead it is a pair of 
    // methods wrapped as a property. As a result the KVCVerification class is likely to throw up too many
    // false warnings to be worthwhile.
    textField.hidden = false
    
    // check that a boolean is OK
    textField.setValue(true, forKey: "hidden")
    XCTAssertEqual(true, textField.hidden)
    XCTAssertNil(KVCVerification.verifyCanSetVale(true, propertyPath: "hidden", destination: textField))
  }
}