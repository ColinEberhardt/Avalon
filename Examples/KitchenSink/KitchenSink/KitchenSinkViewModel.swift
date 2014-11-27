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
  
  override func convert(sourceValue: AnyObject, binding: Binding, viewModel: AnyObject) -> AnyObject? {
    
    let formatter = NSNumberFormatter()
    formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    
    let val = sourceValue as Double
    return formatter.stringFromNumber(val)!
  }
}

@objc(TapsToTitle) class TapsToTitle: ValueConverter {
  override func convert(sourceValue: AnyObject, binding: Binding, viewModel: AnyObject) -> AnyObject? {
    let taps = sourceValue as Int
    return "Button tapped \(taps) times"
  }
}

@objc(IndexToSegmentTitle) class IndexToSegmentTitle: ValueConverter {
  override func convert(sourceValue: AnyObject, binding: Binding, viewModel: AnyObject) -> AnyObject? {
    let index = sourceValue as Int
    let kitchenSink = viewModel as KitchenSinkViewModel
    return kitchenSink.options[index]
  }
}

@objc(DateToString) class DateToString: ValueConverter {
  override func convert(sourceValue: AnyObject, binding: Binding, viewModel: AnyObject) -> AnyObject? {
    let date = sourceValue as NSDate
    return date.description
  }
}

class KitchenSinkViewModel: NSObject {
  
  dynamic var text = "foo"
  
  dynamic var number = 1.0
  dynamic var maxNumber = 100.0
  dynamic var minNumber = 0.0
  
  dynamic var date = NSDate()
  
  dynamic var progress = 0.4
  
  dynamic var buttonTapCount: Int = 0
  
  dynamic let incrementCountCommand: Command!
  
  dynamic var searchText = "search"
  dynamic let searchCommand: Command!
  
  dynamic var selectedOption = 1
  dynamic let options = ["one", "two", "three"]
  
  dynamic var strings = [String]()
  dynamic let stringSelectedCommand: DataCommand!
  
  dynamic var boolean: Bool = true {
    didSet {
      println("updated")
    }
  }
  
  override init() {

    super.init()
    
    for i in 0..<100 {
      strings.append("item #\(i)")
    }
    
    incrementCountCommand = ClosureCommand {
      self.buttonTapCount = self.buttonTapCount + 1
    }
    
    searchCommand = ClosureCommand {
      println("search!!!!!")
    }
    
    stringSelectedCommand = ClosureDataCommand {
      (selectedItem: AnyObject) in
      println(selectedItem)
    }
  }
  
}