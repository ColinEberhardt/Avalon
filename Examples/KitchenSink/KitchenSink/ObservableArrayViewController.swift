//
//  ObservabelArrayViewController.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 15/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import Avalon

class ObservableArrayViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var stepperControl: UIStepper!
  @IBOutlet weak var removeItemButton: UIButton!
  @IBOutlet weak var pickerView: UIPickerView!
  
  let viewModel: ObservableArrayViewModel = {
    return ObservableArrayViewModel()
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    segmentedControl.bindings = [
      "items" >| "segments",
      "selectedItemIndex" |<>| "selectedSegmentIndex"]
    
    tableView.bindings = [
      "items" >| "items",
      "selectedItemIndex" |<>| "selectedItemIndex"]
    
    pickerView.bindings = [
      "items" >| "items",
      "selectedItemIndex" |<>| "selectedItemIndex"]
    
    stepperControl.bindings = [
      "itemIndex" |<>| "value",
      "maxIndex" >| "maximumValue"]
    
    removeItemButton.bindings = [
      "removeItemActionEnabled" >| "enabled"]
    
    view.bindingContext = viewModel
  }
}