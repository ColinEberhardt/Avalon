//
//  NumberToStringConverter.swift
//  ColorPicker
//
//  Created by Colin Eberhardt on 09/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import Avalon

class NumberToString: NSValueTransformer {
  
  override class func load() {
    NSValueTransformer.setValueTransformer(NumberToString(), forName: "NumberToString")
  }
  
  override func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    
    let formatter = NSNumberFormatter()
    formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    
    let val = sourceValue as Double
    return formatter.stringFromNumber(val)!
  }
}