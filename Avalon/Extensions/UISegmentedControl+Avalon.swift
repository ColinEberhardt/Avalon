//
//  UISegmentedControl+Binding.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 08/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Public API
extension UISegmentedControl {
  
  /// An bindable array that represent the segment titles
  public var segments: AnyObject? {
    get {
      return itemsController.items
    }
    set(newValue) {
      itemsController.items = newValue
    }
  }
  
}

// MARK:- Private API
extension UISegmentedControl {
  // an accessor for the controller that handles updating the segmented control
  var itemsController: SegmentedControlItemsController {
    return lazyAssociatedProperty(self, &AssociationKey.itemsController) {
      return SegmentedControlItemsController(segmentedControl: self)
    }
  }
}

// A controller that handles updating the state of a segmented control
class SegmentedControlItemsController: ItemsController {
  
  private let segmentedControl: UISegmentedControl
  
  init(segmentedControl: UISegmentedControl) {
    self.segmentedControl = segmentedControl
    super.init()
  }
  
  override func reloadAllItems() {
    segmentedControl.removeAllSegments()
    if let arrayFacade = arrayFacade {
      for var i = 0; i < arrayFacade.count; i++ {
        insertSegment(arrayFacade.itemAtIndex(i), index: i)
      }
    }
  }
  
  override func arrayUpdated(update: ArrayUpdateType) {
    switch update {
    case .ItemAdded(let index, let item):
      // when adding / removing segments, the selected index is offset. Therefore
      // it needs to be re-applied
      let selectedSegment = segmentedControl.selectedSegmentIndex
      insertSegment(item, index: index)
      segmentedControl.selectedSegmentIndex = selectedSegment
      break
    case .ItemRemoved(let index, let item):
      let selectedSegment = segmentedControl.selectedSegmentIndex
      segmentedControl.removeSegmentAtIndex(index, animated: true)
      segmentedControl.selectedSegmentIndex = selectedSegment
      break
    case .ItemUpdated(let index, let item):
      let selectedSegment = segmentedControl.selectedSegmentIndex
      updatedSegment(item, index: index)
      break
    case .Reset:
      reloadAllItems()
      break
    }
  }
  
  private func updatedSegment(item: AnyObject, index: Int) {
    if let itemString = item as? String {
      segmentedControl.setTitle(itemString, forSegmentAtIndex: index)
    } else {
      ErrorSink.instance.logEvent("ERROR: An array of items that are not strings has been bound to a segmented control. Only arrays of strings are supported.")
    }
  }
  
  private func insertSegment(item: AnyObject, index: Int) {
    if let itemString = item as? String {
      segmentedControl.insertSegmentWithTitle(itemString, atIndex: index, animated: true)
    } else {
      ErrorSink.instance.logEvent("ERROR: An array of items that are not strings has been bound to a segmented control. Only arrays of strings are supported.")
    }
  }
}