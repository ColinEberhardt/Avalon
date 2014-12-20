//
//  AvalonBootstrap.swift
//  Avalon
//
//  Created by Colin Eberhardt on 07/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

@objc class AvalonBootstrap: NSObject {
  override class func load() {
    // delegate method swizzling in order to multiplex calls
    AVSwizzle.swizzleClass(UISearchBar.self, method: "setDelegate:")
    AVSwizzle.swizzleClass(UISearchBar.self, method: "delegate")
    
    // delegate method swizzling in order to multiplex calls
    AVSwizzle.swizzleClass(UITableView.self, method: "setDelegate:")
    AVSwizzle.swizzleClass(UITableView.self, method: "delegate")
    
    // delegate method swizzling in order to multiplex calls
    AVSwizzle.swizzleClass(UITextView.self, method: "setDelegate:")
    AVSwizzle.swizzleClass(UITextView.self, method: "delegate")
    
    // delegate method swizzling in order to multiplex calls
    AVSwizzle.swizzleClass(UIPickerView.self, method: "setDelegate:")
    AVSwizzle.swizzleClass(UIPickerView.self, method: "delegate")
  }
}