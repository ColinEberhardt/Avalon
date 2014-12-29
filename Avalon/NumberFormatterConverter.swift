//
//  NumberFormatterConverter.swift
//  Avalon
//
//  Created by Colin Eberhardt on 24/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation


public class NumberFormatterConverter: ValueConverter {
  
  private let formatter: NSNumberFormatter
  
  init(formatter: NSNumberFormatter) {
    self.formatter = formatter
  }
  
  override public func convert(sourceValue: AnyObject?) -> AnyObject? {
    let numericValue = sourceValue as Double
    return formatter.stringFromNumber(numericValue)
  }
  
  override public func convertBack(sourceValue: AnyObject?) -> AnyObject? {
    if let stringValue = sourceValue as? String {
      return formatter.numberFromString(stringValue)
    }
    return nil
  }
}

@objc(AVConverterDecimalStyle) public class NumberFormatterConverterDecimalStyle: NumberFormatterConverter {
  init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    super.init(formatter: formatter)
  }
}

@objc(AVConverterCurrencyStyle) public class NumberFormatterConverterCurrencyStyle: NumberFormatterConverter {
  init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    super.init(formatter: formatter)
  }
}

@objc(AVConverterPercentStyle) public class NumberFormatterConverterPercentStyle: NumberFormatterConverter {
  init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .PercentStyle
    super.init(formatter: formatter)
  }
}

@objc(AVConverterScientificStyle) public class NumberFormatterConverterScientificStyle: NumberFormatterConverter {
  init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .ScientificStyle
    super.init(formatter: formatter)
  }
}
