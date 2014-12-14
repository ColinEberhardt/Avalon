//
//  ObservableArrayDelegate.swift
//  Avalon
//
//  Created by Colin Eberhardt on 13/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

/// A delegate for receiving notifications
@objc public protocol ObservableArrayDelegate {
  
  /// Is invoked when an item is added to an ObservableArray
  optional func didAddItem(item: AnyObject, atIndex index: Int, inArray array: ObservableArray)

  /// Is invoked when an item is removed from an ObservableArray
  optional func didRemoveItem(item: AnyObject, atIndex index: Int, inArray array: ObservableArray)

}