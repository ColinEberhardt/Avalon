//
//  BindingMode.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 05/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

/// Describes the direction the data flows in a binding
public enum BindingMode: Printable {
  
  /// A one way binding updates the destination property when the source property changes. It does
  /// *not* update the source if the destination changes.
  case OneWay
  
  /// A two way binding propagates changes in both directions, from source to destination and
  /// destination to source.
  case TwoWay
  
  public var description: String {
    switch self {
    case .OneWay:
      return "OneWay"
    case .TwoWay:
      return "TwoWay"
    }
  }
}