//
//  PlaceViewController.swift
//  SwiftPlaces
//
//  Created by Joshua Smith on 7/28/14.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

import UIKit

/** 
Displays detailed information about a place including
its current weather, which is fetched on demand.
*/
class PlaceViewController: UIViewController
{
  var place: Place!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    navigationItem.title = "Place Info"
  
    self.view.bindingContext = PlaceViewModel(place: place)
  }
  
}
