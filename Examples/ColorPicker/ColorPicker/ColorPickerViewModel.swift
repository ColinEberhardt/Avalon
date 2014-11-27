//
//  ColorPickerViewModel.swift
//  ColorPicker
//
//  Created by Colin Eberhardt on 09/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

class ColorPickerViewModel: NSObject {
  
  //MARK: - properties
  
  dynamic let colorModes = ["RGB", "HSL"]
  
  dynamic var red: Double = 0.2 {
    didSet {
      updateColor()
    }
  }
  
  dynamic var green: Double = 0.5 {
    didSet {
      updateColor()
    }
  }
  
  dynamic var blue: Double = 0.7 {
    didSet {
      updateColor()
    }
  }
  
  dynamic var selectedSegmentIndex: Int = 0 {
    didSet {
      if selectedSegmentIndex == 1 {
        convertToHSB()
      } else {
        convertToRGB()
      }
      updateColor()
    }
  }
  
  dynamic var color: UIColor = UIColor.whiteColor()
  
  //MARK: - initialization
  
  override init() {
    super.init()
    updateColor()
  }
  
  //MARK: - private functions
  
  
  private func updateColor() {
    if selectedSegmentIndex == 0 {
      color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    } else {
      color = UIColor(hue: CGFloat(red), saturation: CGFloat(green), brightness: CGFloat(blue), alpha: 1.0)
    }
  }

  
  private func convertToHSB() {
    var hue: CGFloat = 0.0
    var saturation: CGFloat = 0.0
    var brightness: CGFloat = 0.0
    var alpha :CGFloat = 0.0
    color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    red = Double(hue)
    green = Double(saturation)
    blue = Double(brightness)
  }
  
  private func convertToRGB() {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha :CGFloat = 0.0
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    self.red = Double(red)
    self.green = Double(green)
    self.blue = Double(blue)
  }
  
}