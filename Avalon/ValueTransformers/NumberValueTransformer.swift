//
//  NumberValueTransformer.swift
//  Avalon
//
//  Created by Colin Eberhardt on 24/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation


public class NumberValueTransformer: NSValueTransformer {
  
  private let formatter: NSNumberFormatter
  
  public init(formatter: NSNumberFormatter) {
    self.formatter = formatter
  }
  
  override public func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    if let numericValue = sourceValue as? Double {
      return formatter.stringFromNumber(numericValue)
    } else {
      ErrorSink.instance.logEvent("ERROR: the value \(sourceValue) supplied to the value transformer (NumberValueTransformer or subclass) was not numeric")
      return nil
    }
  }
  
  override public func reverseTransformedValue(sourceValue: AnyObject?) -> AnyObject? {
    if let stringValue = sourceValue as? String {
      return formatter.numberFromString(stringValue)
    } else {
      return nil
    }
  }
}

public class NumberValueTransformerIntStyle: NumberValueTransformer {
  override public class func load() {
    NSValueTransformer.setValueTransformer(NumberValueTransformerIntStyle(), forName:"IntStyle")
  }
  
  public init() {
    let formatter = NSNumberFormatter()
    formatter.allowsFloats = false
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    formatter.usesGroupingSeparator = true
    super.init(formatter: formatter)
  }
}

public class NumberValueTransformerDecimalStyle: NumberValueTransformer {
  override public class func load() {
    NSValueTransformer.setValueTransformer(NumberValueTransformerDecimalStyle(), forName:"DecimalStyle")
  }
  
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    super.init(formatter: formatter)
  }
}

public class NumberValueTransformerCurrencyStyle: NumberValueTransformer {
  override public class func load() {
    NSValueTransformer.setValueTransformer(NumberValueTransformerCurrencyStyle(), forName:"CurrencyStyle")
  }
  
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    super.init(formatter: formatter)
  }
}

public class NumberValueTransformerPercentStyle: NumberValueTransformer {
  override public class func load() {
    NSValueTransformer.setValueTransformer(NumberValueTransformerPercentStyle(), forName:"PercentStyle")
  }
  
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .PercentStyle
    super.init(formatter: formatter)
  }
}

public class NumberValueTransformerScientificStyle: NumberValueTransformer {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(NumberValueTransformerScientificStyle(), forName:"ScientificStyle")
  }
  
  public init() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .ScientificStyle
    super.init(formatter: formatter)
  }
}
