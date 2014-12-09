//
//  SplitViewController.swift
//  iTunesDirectory
//
//  Created by Sam Davies on 08/12/2014.
//  Copyright (c) 2014 Avalon. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }
  
  //MARK:- UISplitViewDelegate
  func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
    return true
  }

}
