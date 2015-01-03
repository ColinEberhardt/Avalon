//
//  ViewController.swift
//  Swift Weather
//
//  Created by Jake Lin on 4/06/2014.
//  Copyright (c) 2014 rushjet. All rights reserved.
//

import UIKit
import Avalon

class BoolInvertConverter: NSValueTransformer {
  // TODO: Can value converters be implemented via closures?
  override func transformedValue(sourceValue: AnyObject?) -> AnyObject? {
    return !(sourceValue as Bool)
  }
}

class ViewController: UIViewController {
    
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadingIndicator.bindings = [Binding(source: "loading", destination: "animating"),
      Binding(source: "loading", destination: "hidden", transformer: BoolInvertConverter())]
    
    self.view.bindingContext = SwiftWeatherViewModel()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
}
