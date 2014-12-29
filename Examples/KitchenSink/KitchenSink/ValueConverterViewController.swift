//
//  ValueConverterViewController.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 23/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit

class ValueConverterViewController: UIViewController {
  override func viewDidLoad() {
    view.bindingContext = ValueConverterViewModel()
  }
}
