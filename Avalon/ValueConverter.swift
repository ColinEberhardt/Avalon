//
//  ValueConverter.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 05/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// subclasses NSObject and annotated @objc so that we can generate the
// class instances from strings
@objc public class ValueConverter: NSObject {
  // TODO: This needs a simpler signature
  public func convert(sourceValue: AnyObject, binding: Binding, viewModel: AnyObject) -> AnyObject? {
    return nil
  }
}