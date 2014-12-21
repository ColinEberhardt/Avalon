//
//  SimpleBindingsViewController.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 21/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import Avalon

class SimpleBindingsViewController: UIViewController {
  override func viewDidLoad() {
    self.view.bindingContext = SimpleBindingsViewModel()
  }
}