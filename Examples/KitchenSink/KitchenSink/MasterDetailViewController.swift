//
//  MasterDetailViewController.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 22/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import Avalon

class MasterDetailViewController: UIViewController {
  @IBOutlet weak var contactListTableView: UITableView!
  override func viewDidLoad() {
    
    contactListTableView.bindings = [
      "contacts" >| "items",
      "selectedContactIndex" |<>| "selectedItemIndex"
    ]
    
    self.view.bindingContext = MasterDetailViewModel()
  }
}
