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
    AVSwizzle.swizzleClass(UISearchBar.self, method: "setDelegate:")
    AVSwizzle.swizzleClass(UISearchBar.self, method: "delegate")
  }
}