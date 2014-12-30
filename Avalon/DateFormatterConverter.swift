//
//  DateFormatterConverter.swift
//  Avalon
//
//  Created by Colin Eberhardt on 30/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

public class DateFormatterConverter: ValueConverter {
  
  private let formatter: NSDateFormatter
  
  public init(formatter: NSDateFormatter) {
    self.formatter = formatter
  }
  
  override public func convert(sourceValue: AnyObject?) -> AnyObject? {
    let dateValue = sourceValue as NSDate
    return formatter.stringFromDate(dateValue)
  }
  
  override public func convertBack(sourceValue: AnyObject?) -> AnyObject? {
    if let stringValue = sourceValue as? String {
      return formatter.dateFromString(stringValue)
    }
    return nil
  }
}

@objc(AVDateConverterShortStyle) public class DateFormatterConverterShortStyle: DateFormatterConverter {
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .ShortStyle
    super.init(formatter: formatter)
  }
}

@objc(AVDateConverterShortStyle) public class DateFormatterConverterMediumStyle: DateFormatterConverter {
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    super.init(formatter: formatter)
  }
}

@objc(AVDateConverterShortStyle) public class DateFormatterConverterLongStyle: DateFormatterConverter {
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .LongStyle
    super.init(formatter: formatter)
  }
}

@objc(AVDateConverterShortStyle) public class DateFormatterConverterFullStyle: DateFormatterConverter {
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .FullStyle
    super.init(formatter: formatter)
  }
}

@objc(AVTimeConverterShortStyle) public class TimeFormatterConverterShortStyle: DateFormatterConverter {
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .ShortStyle
    super.init(formatter: formatter)
  }
}

@objc(AVTimeConverterShortStyle) public class TimeFormatterConverterMediumStyle: DateFormatterConverter {
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .MediumStyle
    super.init(formatter: formatter)
  }
}

@objc(AVTimeConverterShortStyle) public class TimeFormatterConverterLongStyle: DateFormatterConverter {
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .LongStyle
    super.init(formatter: formatter)
  }
}

@objc(AVTimeConverterShortStyle) public class TimeFormatterConverterFullStyle: DateFormatterConverter {
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .FullStyle
    super.init(formatter: formatter)
  }
}