//
//  NSValueTransformerTest.swift
//  UnitTests
//
//  Created by Colin Eberhardt on 03/01/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest
import Avalon


class NSValueTransformerTest: XCTestCase {
  
  func test_registerTransformer() {
    NSValueTransformer.setValueTransformerForName("StringTransformer") {
      (value: AnyObject?) -> AnyObject? in
      if let str = value as? NSString {
        return str.uppercaseString
      }
      return nil
    }
    
    let label = UILabel()
    label.bindings = ["." >>| "StringTransformer" >>| "text"]
    label.bindingContext = "fish"
    
    XCTAssertEqual(label.text!, "FISH")
  }
}