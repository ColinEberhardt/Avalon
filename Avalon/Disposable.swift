//
//  Disposable.swift
//  Avalon
//
//  Created by Colin Eberhardt on 09/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

/// An object that has some tear-down logic
public protocol Disposable {
  func dispose()
}
