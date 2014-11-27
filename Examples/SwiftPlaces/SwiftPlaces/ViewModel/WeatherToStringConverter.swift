//
//  WeatherToStringConverter.swift
//  SwiftPlaces
//
//  Created by Colin Eberhardt on 27/11/2014.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

import Foundation
import Avalon

@objc(WeatherToStringConverter) class WeatherToStringConverter: ValueConverter {
  
  private var useCelcius: Bool {
    get { return NSLocale.currentLocale()
      .objectForKey(NSLocaleUsesMetricSystem)!.boolValue }
  }
  
  override func convert(sourceValue: AnyObject?, binding: Binding, viewModel: AnyObject) -> AnyObject? {
    if let weather = sourceValue as? Weather {
      let temp    = useCelcius ? weather.temperatureC : weather.temperatureF
      let symbol  = useCelcius ? "C" : "F"
      return "\(Int(temp))°\(symbol)  \(weather.humidity)% humidity"
    } else {
      return "loading ..."
    }
  }
}