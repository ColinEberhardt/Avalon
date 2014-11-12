//
//  KitchenSinkViewModel.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 11/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import Avalon

@objc(NumberToString) class NumberToString: ValueConverter {
  override func convert(sourceValue: AnyObject) -> AnyObject {
    
    let formatter = NSNumberFormatter()
    formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    
    let val = sourceValue as Double
    return formatter.stringFromNumber(val)!
  }
}

class KitchenSinkViewModel: NSObject {
  
  dynamic var text = "foo"
  
  dynamic var number = 0.8
  dynamic var maxNumber = 100.0
  dynamic var minNumber = 0.0
  
}