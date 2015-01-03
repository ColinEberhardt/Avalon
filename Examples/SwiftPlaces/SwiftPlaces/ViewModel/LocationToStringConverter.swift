//
//  LocationToStringConverter.swift
//  SwiftPlaces
//
//  Created by Colin Eberhardt on 27/11/2014.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

import Foundation
import Avalon

@objc(LocationToStringConverter) class LocationToStringConverter: NSValueTransformer {
  override func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    let placeViewModel = sourceValue as PlaceViewModel
    let formatter = { String(format: "%.2f", $0) }
    let lat = formatter(placeViewModel.place.latitude)
    let lng = formatter(placeViewModel.place.longitude)
    return "(\(lat), \(lng))"
  }
}