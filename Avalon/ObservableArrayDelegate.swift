//
//  ObservableArrayDelegate.swift
//  Avalon
//
//  Created by Colin Eberhardt on 13/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

/// A delegate for receiving notifications
public protocol ObservableArrayDelegate {
  
  /// Is invoked when an item is added to an ObservableArray
  func didAddItem(item: Any, atIndex: Int, array: Any)

  /// Is invoked when an item is removed from an ObservableArray
  func didRemoveItem(item: Any, atIndex: Int, array: Any)

}