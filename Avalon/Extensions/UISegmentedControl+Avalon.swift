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
      return segmentedControlSource.items
    }
    set(newValue) {
      segmentedControlSource.items = newValue
    }
  }
  
}

// MARK:- Private API
extension UISegmentedControl {
  // an accessor for the source that provides data to the segmented control
  var segmentedControlSource: SegmentedControlSource {
    return lazyAssociatedProperty(self, &AssociationKey.tableViewSource) {
      return SegmentedControlSource(segmentedControl: self)
    }
  }
}

class SegmentedControlSource {
  private let segmentedControl: UISegmentedControl
  
  var items: AnyObject? {
    didSet {
      updateAllSegments()
      
      if let items = items as? ObservableArray {
        // TODO: remove this handler at an appropriate time
        items.arrayChangedEvent.addHandler(self, handler: SegmentedControlSource.arrayUpdated)
      }
    }
  }
  
  init(segmentedControl: UISegmentedControl) {
    self.segmentedControl = segmentedControl
  }
  
  func updateAllSegments() {
    segmentedControl.removeAllSegments()
    let arrayFacade = facadeForArray(items)
    for var i = 0; i < arrayFacade.count; i++ {
      if let item = arrayFacade.itemAtIndex(i) as? String {
        segmentedControl.insertSegmentWithTitle(item, atIndex: i, animated: false)
      }
    }
  }
  
  func arrayUpdated(update: ArrayUpdateType) {
    switch update {
    case .ItemAdded(let index, let item):
      if let itemString = item as? String {
        segmentedControl.insertSegmentWithTitle(itemString, atIndex: index, animated: true)
      }
      break
    case .ItemRemoved(let index, let item):
      segmentedControl.removeSegmentAtIndex(index, animated: true)
      break
    }
  }
}