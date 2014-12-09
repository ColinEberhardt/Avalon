//
//  ViewController.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 11/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import Avalon


class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {

  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    slider.bindings = [Binding(source: "maxNumber", destination: "maximumValue"),
      Binding(source: "minNumber", destination: "minimumValue")]

    button.bindings = [ "incrementCountAction" >| "Action" ]
    
    label.bindings = ["number" >| NumberToString() >| "text"]
    
    segmentedControl.bindings = [Binding(source: "options", destination: "segments"),
      Binding(source: "selectedOption", destination: "selectedSegmentIndex", mode: .TwoWay)]
    
    searchBar.bindings = [Binding(source: "searchText", destination: "text", mode: .TwoWay),
      Binding(source:"searchPlaceholder", destination:"placeholder"),
      Binding(source: "options", destination: "scopeButtonTitles"),
      Binding(source: "selectedOption", destination: "selectedScopeButtonIndex", mode: .TwoWay)
    ]
    
    tableView.bindings = [Binding(source: "stringSelectedAction", destination: "selectionAction")]
   
    view.bindingContext = KitchenSinkViewModel()
    
    // test delegate forwarding
    searchBar.delegate = self
    tableView.delegate = self
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    println(searchText)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("selected row \(indexPath)")
  }
  
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    println("de-selected row \(indexPath)")
  }
  
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    println("drag")
  }

}

