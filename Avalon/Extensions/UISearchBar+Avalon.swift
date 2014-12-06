//
//  UISearchBar+Avalon.swift
//  Avalon
//
//  Created by Colin Eberhardt on 21/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit

extension UISearchBar {
  
  
  public var searchAction: Action? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.searchAction) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.searchAction, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  public var cancelAction: Action? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.cancelAction) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.cancelAction, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  public var resultsListButtonAction: Action? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.resultsListButtonAction) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.resultsListButtonAction, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  public var bookmarkButtonAction: Action? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.bookmarkButtonAction) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.bookmarkButtonAction, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  var searchBarDelegate: UISearchBarDelegateImpl {
    get {
      let  delegate = objc_getAssociatedObject(self, &AssociationKey.searchBarDelegate) as? UISearchBarDelegateImpl
      
      // TODO: provide delegate forwarding so that the user can still use this controls delegate
      if delegate == nil {
        let delegateImpl = UISearchBarDelegateImpl(searchBar: self)
        self.searchBarDelegate = delegateImpl
        return delegateImpl
      } else {
        return delegate!
      }
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.searchBarDelegate, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
}

// a delegate implementation, used to detect button clicks
// and text change
class UISearchBarDelegateImpl: NSObject, UISearchBarDelegate {
  private let searchBar: UISearchBar
  
  // an observer that is invoked when text changes, this is used
  // to support two-way binding
  var textChangedObserver: (String->())?
  
  // an observer that is invoked when the selected scope button changes, this is used
  // to support two-way binding
  var scopeButtonIndexChanged: (Int->())?
  
  init(searchBar: UISearchBar) {
    self.searchBar = searchBar

    super.init()
    
    searchBar.delegate = self
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