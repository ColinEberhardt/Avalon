//
//  ViewController.swift
//  Swift Weather
//
//  Created by Jake Lin on 4/06/2014.
//  Copyright (c) 2014 rushjet. All rights reserved.
//

import UIKit
import Avalon

class BoolInvertConverter: ValueConverter {
  // TODO: Can value converters be implemented via closures?
  override func convert(sourceValue: AnyObject?, binding: Binding, viewModel: AnyObject) -> AnyObject? {
    return !(sourceValue as Bool)
  }
}

class ViewController: UIViewController {
    
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadingIndicator.bindings = [Binding(source: "loading", destination: "animating"),
      Binding(source: "loading", destination: "hidden", converter: BoolInvertConverter())]
    
    self.view.bindingContext = SwiftWeatherViewModel()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
}
