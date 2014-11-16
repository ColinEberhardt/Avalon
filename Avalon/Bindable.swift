//
//  Bindable.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 05/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

@objc public protocol Bindable {
  
  var source: String { get set }
  
  var destination: String { get set }

  var converter: String { get set }

  var mode: String { get set }
  
  var bindings: [Binding]? { get set }
}
