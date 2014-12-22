//
//  TwoWayBindingViewController.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 22/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import Avalon

class TwoWayBindingViewController: UIViewController {
  
  @IBOutlet weak var pickerView: UIPickerView!
  
  override func viewDidLoad() {
    pickerView.items = ["one", "two", "three"]
    self.view.bindingContext = TwoWayBindingViewModel()
  }
}
