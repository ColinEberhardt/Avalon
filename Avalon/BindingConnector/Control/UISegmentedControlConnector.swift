//
//  UISegmentedControlConnector.swift
//  Avalon
//
//  Created by Colin Eberhardt on 10/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

class UISegmentedControlConnector: UIControlBindingConnector {
  
  init?(source: NSObject, segmentedControl: UISegmentedControl, binding: Binding) {
    super.init(source: source, destination: segmentedControl, valueExtractor: { segmentedControl.selectedSegmentIndex }, binding: binding)
    
    if binding.destinationProperty != "selectedSegmentIndex" {
      println("ERROR: view \(segmentedControl) does not support two-way binding, with binding \(binding)");
      return nil
    }
  }
}