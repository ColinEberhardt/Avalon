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
  
  public init(formatter: NSNumberFormatter) {
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

@objc(AVNumberConverterDecimalStyle) public class NumberFormatterConverterDecimalStyle: NumberFormatterConverter {
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    super.init(formatter: formatter)
  }
}

@objc(AVNumberConverterCurrencyStyle) public class NumberFormatterConverterCurrencyStyle: NumberFormatterConverter {
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    super.init(formatter: formatter)
  }
}

@objc(AVNumberConverterPercentStyle) public class NumberFormatterConverterPercentStyle: NumberFormatterConverter {
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .PercentStyle
    super.init(formatter: formatter)
  }
}

@objc(AVNumberConverterScientificStyle) public class NumberFormatterConverterScientificStyle: NumberFormatterConverter {
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .ScientificStyle
    super.init(formatter: formatter)
  }
}
