//
//  ViewController.swift
//  ColorPicker
//
//  Created by Colin Eberhardt on 09/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import Avalon

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bindings = [Binding(source: "colorModes", destination: "segments"),
      Binding(source: "selectedSegmentIndex", destination: "selectedSegmentIndex", mode: .TwoWay)]
    
    self.view.bindingContext = ColorPickerViewModel()
   
  }

}

