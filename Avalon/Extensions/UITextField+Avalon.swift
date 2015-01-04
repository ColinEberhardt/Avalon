//
//  UITextField+Avalon.swift
//  Avalon
//
//  Created by Colin Eberhardt on 21/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

/// Indicates when the source property will be updated when using TwoWay binding
public enum BindingUpdateMode: String {
  /// The source property is updated on every change
  case OnChange = "OnChange"
  /// The source property is updated when the view / control resigns the first responder
  case OnResignResponder = "OnResignResponder"
}

extension UITextField {
  
  /// Indicates when the source property will be updated when using TwoWay binding
  public var bindingUpdateMode: BindingUpdateMode {
    get {
      if let bindingUpdateMode = BindingUpdateMode(rawValue: bindingUpdateModeString) {
        return bindingUpdateMode
      }
      ErrorSink.instance.logEvent("ERROR: A binding update mode of \(bindingUpdateModeString) is not permitted. See the BindingUpdateMode enum for accepted values")
      return .OnChange
    }
    set(newValue) {
      bindingUpdateModeString = newValue.rawValue
    }
  }
  
  /// Indicates when the source property will be updated when using TwoWay binding
  @IBInspectable public var bindingUpdateModeString: String {
    get {
      return getAssociatedProperty(self, &AssociationKey.bindingUpdateMode, "OnChange")
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.bindingUpdateMode, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  /// If true, will resign the first responder when the enter key is pressed
  @IBInspectable public var resignFirstResponderOnReturn: Bool {
    get {
      return getAssociatedProperty(self, &AssociationKey.resignFirstResponderOnEnter, false)
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.resignFirstResponderOnEnter, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
}

// MARK:- Delegate forwarding.
extension UITextField {
  // subclasses AVDelegateMultiplexer to adopt the UITextFieldDelegate protocol
  class TextFieldDelegateMultiplexer: AVDelegateMultiplexer, UITextFieldDelegate {
  }
  
  public override func didMoveToWindow() {
    // replace the delegate with the multiplexer
    if (!viewInitialized) {
      delegateMultiplexer.delegate = self.delegate
      self.delegate = delegateMultiplexer
      delegateMultiplexer.proxiedDelegate = self.textFieldDelegate
      viewInitialized = true
    }
  }
  
  func replaceDelegateWithMultiplexer() {
    delegateMultiplexer.delegate = self.delegate
    self.delegate = delegateMultiplexer
  }
  
  // a multiplexer that provides forwarding
  var delegateMultiplexer: TextFieldDelegateMultiplexer {
    return lazyAssociatedProperty(self, &AssociationKey.delegateMultiplex) {
      return TextFieldDelegateMultiplexer()
    }
  }
  
  func override_setDelegate(delegate: AnyObject) {
    if !viewInitialized {
      self.override_setDelegate(delegate)
    } else {
      delegateMultiplexer.delegate = delegate
    }
  }
  func override_delegate() -> UITextFieldDelegate? {
    if !viewInitialized {
      return self.override_delegate()
    } else {
      // Regardless of what delegate the user specified, we must return the multiplexer
      // as the delegate value. Otherwise the table view will not invoke methods on the multiplexer.
      return delegateMultiplexer
    }
  }
}

// MARK:- Private API
extension UITextField {
  
  // the delegate that is used to handle text changes
  var textFieldDelegate: UITextFieldDelegateImpl {
    return lazyAssociatedProperty(self, &AssociationKey.searchBarDelegate) {
      return UITextFieldDelegateImpl(textField: self)
    }
  }
}

class UITextFieldDelegateImpl: NSObject, UITextFieldDelegate {
  private let textField: UITextField
  
  init(textField: UITextField) {
    self.textField = textField
    
    super.init()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField.resignFirstResponderOnReturn {
      textField.resignFirstResponder()
    }
    return true
  }
}