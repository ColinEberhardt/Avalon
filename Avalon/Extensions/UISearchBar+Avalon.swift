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
      return objc_getAssociatedObject(self, &actionAssociationKey) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &actionAssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  var searchBarDelegate: UISearchBarDelegateImpl {
    get {
      let  delegate = objc_getAssociatedObject(self, &searchBarDelegateAssociationKey) as? UISearchBarDelegateImpl
      
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
      objc_setAssociatedObject(self, &searchBarDelegateAssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
}

class UISearchBarDelegateImpl: NSObject, UISearchBarDelegate {
  private let searchBar: UISearchBar
  
  var textChangedObserver: (String->())?
  
  init(searchBar: UISearchBar) {
    self.searchBar = searchBar

    super.init()
    
    searchBar.delegate = self
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.searchAction?.execute()
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    if let observer = textChangedObserver {
      observer(searchBar.text)
    }
  }
}