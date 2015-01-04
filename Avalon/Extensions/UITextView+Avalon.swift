//
//  UITextView+Avalon.swift
//  Avalon
//
//  Created by Colin Eberhardt on 11/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// MARK:- Private API
extension UITextView {
  
  // the delegate that is used to handle text changes
  var textViewDelegate: UITextViewDelegateImpl {
    return lazyAssociatedProperty(self, &AssociationKey.searchBarDelegate) {
      return UITextViewDelegateImpl(textView: self)
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
}

// MARK:- Delegate forwarding.
extension UITextView {
  // subclasses AVDelegateMultiplexer to adopt the UITextViewDelegate protocol
  class TextViewDelegateMultiplexer: AVDelegateMultiplexer, UITextViewDelegate {
  }
  
  public override func didMoveToWindow() {
    // replace the delegate with the multiplexer
    if (!viewInitialized) {
      delegateMultiplexer.delegate = self.delegate
      self.delegate = delegateMultiplexer
      viewInitialized = true
    }
  }
  
  func replaceDelegateWithMultiplexer() {
    delegateMultiplexer.delegate = self.delegate
    self.delegate = delegateMultiplexer
  }
  
  // a multiplexer that provides forwarding
  var delegateMultiplexer: TextViewDelegateMultiplexer {
    return lazyAssociatedProperty(self, &AssociationKey.delegateMultiplex) {
      return TextViewDelegateMultiplexer()
    }
  }
  
  func override_setDelegate(delegate: AnyObject) {
    if !viewInitialized {
      self.override_setDelegate(delegate)
    } else {
      delegateMultiplexer.delegate = delegate
    }
  }
  func override_delegate() -> UITextViewDelegate? {
    if !viewInitialized {
      return self.override_delegate()
    } else {
      // Regardless of what delegate the user specified, we must return the multiplexer
      // as the delegate value. Otherwise the table view will not invoke methods on the multiplexer.
      return delegateMultiplexer
    }
  }
}

class UITextViewDelegateImpl: NSObject, UITextViewDelegate {
  
  private let textView: UITextView
  
  // an observer that is invoked when text changes, this is used
  // to support two-way binding
  var textChangedObserver: ValueChangedNotification?
  
  init(textView: UITextView) {
    self.textView = textView
    
    super.init()
    
    textView.delegateMultiplexer.proxiedDelegate = self
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if textView.bindingUpdateMode == .OnResignResponder {
      textChangedObserver?(textView.text)
    }
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    if text == "\n" && textView.resignFirstResponderOnReturn {
      textView.resignFirstResponder()
      return false
    }
    
    return true
  }
  
  func textViewDidChange(textView: UITextView) {
    if textView.bindingUpdateMode == .OnChange {
      textChangedObserver?(textView.text)
    }
  }
}
