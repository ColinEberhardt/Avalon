//
//  DateValueTransformer.swift
//  Avalon
//
//  Created by Colin Eberhardt on 30/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

public class DateValueTransformer: NSValueTransformer {
  
  private let formatter: NSDateFormatter
  
  public init(formatter: NSDateFormatter) {
    self.formatter = formatter
  }
  
  override public func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    if let dateValue = sourceValue as? NSDate {
      return formatter.stringFromDate(dateValue)
    } else {
      ErrorSink.instance.logEvent("ERROR: the value \(sourceValue) supplied to the value transformer (DateValueTransformer or subclass) was not an NSDate instance")
      return nil
    }
  }
  
  override public func reverseTransformedValue(sourceValue: AnyObject?) -> AnyObject? {
    if let stringValue = sourceValue as? String {
      return formatter.dateFromString(stringValue)
    }
    return nil
  }
}

public class DateValueTransformerShortStyle: DateValueTransformer {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(DateValueTransformerShortStyle(), forName:"DateShortStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .ShortStyle
    super.init(formatter: formatter)
  }
}

public class DateValueTransformerMediumStyle: DateValueTransformer {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(DateValueTransformerMediumStyle(), forName:"DateMediumStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    super.init(formatter: formatter)
  }
}

public class DateValueTransformerLongStyle: DateValueTransformer {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(DateValueTransformerLongStyle(), forName:"DateLongStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .LongStyle
    super.init(formatter: formatter)
  }
}

public class DateValueTransformerFullStyle: DateValueTransformer {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(DateValueTransformerFullStyle(), forName:"DateFullStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .FullStyle
    super.init(formatter: formatter)
  }
}

public class TimeValueTransformerShortStyle: DateValueTransformer {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(TimeValueTransformerShortStyle(), forName:"TimeShortStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .ShortStyle
    super.init(formatter: formatter)
  }
}

public class TimeValueTransformerMediumStyle: DateValueTransformer {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(TimeValueTransformerMediumStyle(), forName:"TimeMediumStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .MediumStyle
    super.init(formatter: formatter)
  }
}

public class TimeValueTransformerLongStyle: DateValueTransformer {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(TimeValueTransformerLongStyle(), forName:"TimeLongStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .LongStyle
    super.init(formatter: formatter)
  }
}

public class TimeValueTransformerFullStyle: DateValueTransformer {
  
  override public class func load() {
    NSValueTransformer.setValueTransformer(TimeValueTransformerFullStyle(), forName:"TimeFullStyle")
  }
  
  public init() {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .FullStyle
    super.init(formatter: formatter)
  }
}