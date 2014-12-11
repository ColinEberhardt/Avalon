//
//  ExtensionPropertyKeys.swift
//  Avalon
//
//  Created by Colin Eberhardt on 17/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

struct AssociationKey {
  static var bindingContext: UInt8 = 0
  static var binding: UInt8 = 1
  static var source: UInt8 = 2
  static var destination: UInt8 = 3
  static var converter: UInt8 = 4
  static var mode: UInt8 = 5
  static var action: UInt8 = 6
  static var segments: UInt8 = 7
  static var animating: UInt8 = 8
  static var tableViewSource: UInt8 = 9
  static var searchCommand: UInt8 = 10
  static var searchBarDelegate: UInt8 = 11
  static var searchAction: UInt8 = 12
  static var cancelAction: UInt8 = 13
  static var resultsListButtonAction: UInt8 = 14
  static var bookmarkButtonAction: UInt8 = 15
  static var delegateMultiplex: UInt8 = 16
  static var delegate: UInt8 = 17
  static var tableViewInitialized: UInt8 = 17
  static var options: UInt8 = 18
}