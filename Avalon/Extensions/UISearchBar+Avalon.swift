//
//  UISearchBar+Avalon.swift
//  Avalon
//
//  Created by Colin Eberhardt on 21/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit

// MARK:- Public API 
// These user interactions would be detected via the delegate. By converting
// them into actions they can be bound to the view model.
extension UISearchBar {
  
  /// An action that is invoked when the search button is clicked
  public var searchAction: Action? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.searchAction) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.searchAction, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  /// An action that is invoked when the cancel button is clicked
  public var cancelAction: Action? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.cancelAction) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.cancelAction, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  /// An action that is invoked when the results list button is clicked
  public var resultsListButtonAction: Action? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.resultsListButtonAction) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.resultsListButtonAction, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  /// An action that is invoked when the bookmark button is clicked
  public var bookmarkButtonAction: Action? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.bookmarkButtonAction) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.bookmarkButtonAction, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
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


// MARK:- Private API
extension UISearchBar {
  
  // the delegate that is used to provide the public action
  var searchBarDelegate: UISearchBarDelegateImpl {
    return lazyAssociatedProperty(self, &AssociationKey.searchBarDelegate) {
      return UISearchBarDelegateImpl(searchBar: self)
    }
  }
}

// MARK:- Delegate forwarding.
extension UISearchBar {
  // subclasses AVDelegateMultiplexer to adopt the UISearchBarDelegate protocol
  class SearchBarDelegateMultiplexer: AVDelegateMultiplexer, UISearchBarDelegate {
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
  var delegateMultiplexer: SearchBarDelegateMultiplexer {
    return lazyAssociatedProperty(self, &AssociationKey.delegateMultiplex) {
      return SearchBarDelegateMultiplexer()
    }
  }
  
  func override_setDelegate(delegate: AnyObject) {
    if !viewInitialized {
      self.override_setDelegate(delegate)
    } else {
      delegateMultiplexer.delegate = delegate
    }
  }
  func override_delegate() -> UISearchBarDelegate? {
    if !viewInitialized {
      return self.override_delegate()
    } else {
      // Regardless of what delegate the user specified, we must return the multiplexer
      // as the delegate value. Otherwise the table view will not invoke methods on the multiplexer.
      return delegateMultiplexer
    }
  }
}

// a delegate implementation, used to detect button clicks
// and text change
class UISearchBarDelegateImpl: NSObject, UISearchBarDelegate {
  private let searchBar: UISearchBar
  
  // an observer that is invoked when text changes, this is used
  // to support two-way binding
  var textChangedObserver: ValueChangedNotification?
  
  // an observer that is invoked when the selected scope button changes, this is used
  // to support two-way binding
  var scopeButtonIndexChanged: ValueChangedNotification?
  
  init(searchBar: UISearchBar) {
    self.searchBar = searchBar

    super.init()
    
    searchBar.delegateMultiplexer.proxiedDelegate = self
  }
  
  func searchBarResultsListButtonClicked(searchBar: UISearchBar) {
    searchBar.resultsListButtonAction?.execute()
  }
  
  func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
    searchBar.bookmarkButtonAction?.execute()
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.cancelAction?.execute()
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    if searchBar.bindingUpdateMode == .OnResignResponder {
      textChangedObserver?(searchBar.text)
    }
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    if searchBar.resignFirstResponderOnReturn {
      searchBar.resignFirstResponder()
    }
    searchBar.searchAction?.execute()
  }
  
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    scopeButtonIndexChanged?(selectedScope)
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.bindingUpdateMode == .OnChange {
      textChangedObserver?(searchBar.text)
    }
  }
}