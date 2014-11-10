//
//  BindingMode.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 05/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

public enum BindingMode: Printable {
  case OneWay, TwoWay
  
  public var description: String {
    switch self {
    case .OneWay:
      return "OneWay"
    case .TwoWay:
      return "TwoWay"
    }
  }
}