//
//  NumberFormatterConverter.swift
//  Avalon
//
//  Created by Colin Eberhardt on 24/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation


public class NumberFormatterConverter: NSValueTransformer {
  
  private let formatter: NSNumberFormatter
  
  public init(formatter: NSNumberFormatter) {
    self.formatter = formatter
  }
  
  override public func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    let numericValue = sourceValue as Double
    return formatter.stringFromNumber(numericValue)
  }
  
  override public func reverseTransformedValue(sourceValue: AnyObject?) -> AnyObject? {
    if let stringValue = sourceValue as? String {
      return formatter.numberFromString(stringValue)
    }
    return nil
  }
}

public class NumberFormatterConverterDecimalStyle: NumberFormatterConverter {
  override public class func load() {
    NSValueTransformer.setValueTransformer(NumberFormatterConverterDecimalStyle(), forName:"AVConverterDecimalStyle")
  }
  
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    super.init(formatter: formatter)
  }
}

public class NumberFormatterConverterCurrencyStyle: NumberFormatterConverter {
  override public class func load() {
    NSValueTransformer.setValueTransformer(NumberFormatterConverterCurrencyStyle(), forName:"AVConverterCurrencyStyle")
  }
  
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    super.init(formatter: formatter)
  }
}

public class NumberFormatterConverterPercentStyle: NumberFormatterConverter {
  override public class func load() {
    NSValueTransformer.setValueTransformer(NumberFormatterConverterPercentStyle(), forName:"AVConverterPercentStyle")
  }
  
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .PercentStyle
    super.init(formatter: formatter)
  }
}

public class NumberFormatterConverterScientificStyle: NumberFormatterConverter {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(NumberFormatterConverterScientificStyle(), forName:"AVConverterScientificStyle")
  }
  
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .ScientificStyle
    super.init(formatter: formatter)
  }
}
