//
//  TwoWayBindingViewMovel.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 22/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import Avalon

class ValueToString: NSValueTransformer {
  override class func load() {
    NSValueTransformer.setValueTransformer(ValueToString(), forName: "ValueToString")
  }
  
  override func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    return "\(sourceValue!)"
  }
}

class TwoWayBindingViewModel: NSObject {
  
  dynamic var textFieldText = "text field"
  
  dynamic var textViewValue = "text view"
  
  dynamic var searchBarText = "search"
  
  dynamic var sliderValue = 0.7
  
  dynamic var switchState = false
  
  dynamic var dateValue: NSDate = NSDate()
  
  dynamic var segmentIndex = 0
  
  dynamic var stepperValue = 0
  
  dynamic var pickerIndex = 0
}
