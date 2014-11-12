//
//  ViewController.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 11/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import Avalon

class ViewController: UIViewController {

  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  //  slider.bindings = [Binding(source: "maxNumber", destination: "maximumValue"),
    //  Binding(source: "minNumber", destination: "minimumValue")]
    
    view.bindingContext = KitchenSinkViewModel()
    
  }

}

