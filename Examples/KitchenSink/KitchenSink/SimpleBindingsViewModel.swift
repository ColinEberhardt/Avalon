//
//  SimpleBindingsViewModel.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 21/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import MapKit
import Avalon

func reverseString(str: String) -> String {
  var newString = ""
  for chr in str {
    newString = String(chr) + newString
  }
  return newString
}

class SimpleBindingsViewModel: NSObject {
  
  dynamic var labelText = "label"
  
  dynamic var textFieldText = "text field"
  
  dynamic var sliderValue = 0.7
  
  dynamic var switchState = false
  
  dynamic var date = NSDate(timeIntervalSinceNow: 100)
  
  dynamic var coordinate = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
  
  dynamic var image = UIImage(named: "10272081.jpg")
  
  dynamic let buttonClickedAction: Action!
  
  override init() {
    
    super.init()
    
    buttonClickedAction = ClosureAction {
      self.labelText = reverseString(self.labelText)
      self.textFieldText = reverseString(self.textFieldText)
      self.sliderValue = 1 - self.sliderValue
      self.switchState = !self.switchState
      self.date = self.date.dateByAddingTimeInterval(60*60*26+5)
      self.image = self.switchState ? UIImage(named: "10272081.jpg") : UIImage(named: "Avalon.png")
      self.coordinate = self.switchState ? CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0) : CLLocationCoordinate2D(latitude: 40.0, longitude: 40.0)
    }
  }
}