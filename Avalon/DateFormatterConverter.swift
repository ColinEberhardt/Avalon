//
//  DateFormatterConverter.swift
//  Avalon
//
//  Created by Colin Eberhardt on 30/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

public class DateFormatterConverter: NSValueTransformer {
  
  private let formatter: NSDateFormatter
  
  public init(formatter: NSDateFormatter) {
    self.formatter = formatter
  }
  
  override public func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    let dateValue = sourceValue as NSDate
    return formatter.stringFromDate(dateValue)
  }
  
  override public func reverseTransformedValue(sourceValue: AnyObject?) -> AnyObject? {
    if let stringValue = sourceValue as? String {
      return formatter.dateFromString(stringValue)
    }
    return nil
  }
}

public class DateFormatterConverterShortStyle: DateFormatterConverter {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(DateFormatterConverterShortStyle(), forName:"AVDateConverterShortStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .ShortStyle
    super.init(formatter: formatter)
  }
}

public class DateFormatterConverterMediumStyle: DateFormatterConverter {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(DateFormatterConverterMediumStyle(), forName:"AVDateConverterMediumStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    super.init(formatter: formatter)
  }
}

public class DateFormatterConverterLongStyle: DateFormatterConverter {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(DateFormatterConverterLongStyle(), forName:"AVDateConverterLongStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .LongStyle
    super.init(formatter: formatter)
  }
}

public class DateFormatterConverterFullStyle: DateFormatterConverter {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(DateFormatterConverterFullStyle(), forName:"AVDateConverterFullStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .FullStyle
    super.init(formatter: formatter)
  }
}

public class TimeFormatterConverterShortStyle: DateFormatterConverter {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(TimeFormatterConverterShortStyle(), forName:"AVTimeConverterShortStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .ShortStyle
    super.init(formatter: formatter)
  }
}

public class TimeFormatterConverterMediumStyle: DateFormatterConverter {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(TimeFormatterConverterMediumStyle(), forName:"AVTimeConverterMediumStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .MediumStyle
    super.init(formatter: formatter)
  }
}

public class TimeFormatterConverterLongStyle: DateFormatterConverter {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(TimeFormatterConverterLongStyle(), forName:"AVTimeConverterLongStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .LongStyle
    super.init(formatter: formatter)
  }
}

public class TimeFormatterConverterFullStyle: DateFormatterConverter {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(TimeFormatterConverterFullStyle(), forName:"AVTimeConverterFullStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .FullStyle
    super.init(formatter: formatter)
  }
}