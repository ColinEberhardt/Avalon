//
//  KitchenSinkViewModel.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 11/11/2014.
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

class URLStringToUIImage: NSValueTransformer {
  
  override class func load() {
    NSValueTransformer.setValueTransformer(URLStringToUIImage(), forName: "URLStringToUIImage")
  }
  
  override func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    let imageUrl = sourceValue as String
    if let url = NSURL(string: imageUrl) {
      if let data = NSData(contentsOfURL: url) {
        return UIImage(data: data)
      }
    }
    return nil
  }
}

class NamedImageToUIImage: NSValueTransformer {
  
  override class func load() {
    NSValueTransformer.setValueTransformer(NamedImageToUIImage(), forName: "NamedImageToUIImage")
  }
  
  override func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    let imageName = sourceValue as String
    return UIImage(named: imageName)
  }
}

class TapsToTitle: NSValueTransformer {
  
  override class func load() {
    NSValueTransformer.setValueTransformer(TapsToTitle(), forName: "TapsToTitle")
  }
  
  
  override func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    let taps = sourceValue as Int
    return "Button tapped \(taps) times"
  }
}

class DateToString: NSValueTransformer {
  
  override class func load() {
    NSValueTransformer.setValueTransformer(DateToString(), forName: "DateToString")
  }
  
  override func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
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
  
  dynamic let incrementCountAction: Action!
  
  dynamic let imageUrl = "http://www.scottlogic.com/blog/hpowell/assets/featured/functional.jpg"
  
  dynamic let imageName = "Avalon"
  
  dynamic var searchText = "search"
  dynamic var searchPlaceholder = "search here!"
  dynamic let searchAction: Action!
  
  dynamic var selectedOption = 1
  dynamic let options = ["one", "two", "three"]
  
  dynamic var strings = [String]()
  dynamic let stringSelectedAction: DataAction!
  
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
    
    incrementCountAction = ClosureAction {
      self.buttonTapCount = self.buttonTapCount + 1
    }
    
    searchAction = ClosureAction {
      println("search button clicked")
    }
    
    stringSelectedAction = ClosureDataAction {
      (selectedItem: AnyObject) in
      println(selectedItem)
    }
  }
  
}