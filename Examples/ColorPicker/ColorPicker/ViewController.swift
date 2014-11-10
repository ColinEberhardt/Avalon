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

  @IBOutlet weak var colorModesSelector: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    colorModesSelector.bindings = [Binding(source: "colorModes", destination: "segments"),
      Binding(source: "selectedSegmentIndex", destination: "selectedSegmentIndex", mode: .TwoWay)]
    
    self.view.bindingContext = ColorPickerViewModel()
   
  }

}

