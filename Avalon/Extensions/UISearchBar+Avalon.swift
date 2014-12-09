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
}

// MARK: Private - add delegate handling
// In order to suport the various actions on the public API, a search bar delegate
// handler is added. This extensions provides access to the delegate, together
// with a forwarding mechanism so that the user can still add their own delegate.
extension UISearchBar {
  
  // the delegate that is used to provide the public action
  var searchBarDelegate: UISearchBarDelegateImpl {
    return lazyAssociatedProperty(self, &AssociationKey.searchBarDelegate) {
      return UISearchBarDelegateImpl(searchBar: self)
    }
  }
  
  // a multiplexer that provides forwarding
  var delegateMultiplexer: AVDelegateMultiplexer {
    return lazyAssociatedProperty(self, &AssociationKey.delegateMultiplex) {
      let multiplexer = AVDelegateMultiplexer()
      self.override_setDelegate(multiplexer)
      return multiplexer
    }
  }
  
  // the swizzled delegate API methods
  func override_setDelegate(delegate: AnyObject) {
    delegateMultiplexer.delegate = delegate
  }
  func override_delegate() -> UISearchBarDelegate? {
    // don't invoke delegateMultiplexer getter in order to check for nil, this
    // can cause a circular invocation
    if objc_getAssociatedObject(self, &AssociationKey.delegateMultiplex) == nil {
      return nil
    } else {
      return delegateMultiplexer.delegate as UISearchBarDelegate?
    }
  }
}

// a delegate implementation, used to detect button clicks
// and text change
class UISearchBarDelegateImpl: NSObject, UISearchBarDelegate {
  private let searchBar: UISearchBar
  
  // an observer that is invoked when text changes, this is used
  // to support two-way binding
  var textChangedObserver: (AnyObject->())?
  
  // an observer that is invoked when the selected scope button changes, this is used
  // to support two-way binding
  var scopeButtonIndexChanged: (AnyObject->())?
  
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
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.searchAction?.execute()
  }
  
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    scopeButtonIndexChanged?(selectedScope)
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    textChangedObserver?(searchBar.text)
  }
}