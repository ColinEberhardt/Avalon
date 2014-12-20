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
  
  func textViewDidChange(textView: UITextView) {
    textChangedObserver?(textView.text)
  }
}
