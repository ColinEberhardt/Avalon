//
//  ItemsController.swift
//  Avalon
//
//  Created by Colin Eberhardt on 18/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// An items controller is responsible for taking a bound array of items, and using this to
// update a controls / view that render collections of items (e.g. table view, segmented control).
// This is an abstract class, where subclasses implemented the control specific logic required
// for updating the UI.
class ItemsController: NSObject {
  
  // the items that are bound to this control
  var items: AnyObject? {
    didSet {
      arrayFacade = facadeForArray(items)
      reloadAllItems()
      
      if let items = items as? ObservableArray {
        // TODO: remove this handler at an appropriate time
        items.arrayChangedEvent.addHandler(self, handler: ItemsController.arrayUpdated)
      }
    }
  }
  
  // a facade that adapts the items property
  var arrayFacade: ArrayFacade?
  
  override init() { }
  
  // Informs the subclass that it needs to refresh the entire UI
  func reloadAllItems() { }
  
  // Informs the subclass of observable array updates
  func arrayUpdated(update: ArrayUpdateType) { }
}