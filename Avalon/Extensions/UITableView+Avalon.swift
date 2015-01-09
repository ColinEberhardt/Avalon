//
//  UITableView+Avalon.swift
//  Avalon
//
//  Created by Colin Eberhardt on 17/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Public API
extension UITableView {
  
  /// A bindable array of objects to render within the table view
  public var items: AnyObject? {
    get {
      return itemsController.items
    }
    set(newValue) {
      itemsController.items = newValue
    }
  }
  
  /// An action which is executed when an item is selected. The data associated with this
  /// action is the newly selected item.
  public var selectionAction: DataAction? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.action) as DataAction?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.action, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  /// The currently selected item index
  public var selectedItemIndex: Int {
    get {
      return itemsController.selectedItemIndex
    }
    set(newValue) {
      itemsController.selectedItemIndex = newValue
    }
  }
  
  /// The currently selected item index
  @IBInspectable public var cellName: String {
    get {
      return getAssociatedProperty(self, &AssociationKey.cellName, "Cell")
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.cellName, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
}


// MARK:- Private API
extension UITableView {
  // an accessor for the controller that handles updating the segmented control
  var itemsController: TableViewItemsController {
    return lazyAssociatedProperty(self, &AssociationKey.itemsController) {
      return TableViewItemsController(tableView: self)
    }
  }
}

// MARK:- Delegate forwarding.
extension UITableView {
  // subclasses AVDelegateMultiplexer to adopt the UITableViewDelegate protocol
  class TableViewDelegateMultiplexer: AVDelegateMultiplexer, UITableViewDelegate {
  }
  
  public override func didMoveToWindow() {
    // replace the delegate with the multiplexer
    if (!viewInitialized) {
      delegateMultiplexer.delegate = self.delegate
      self.delegate = delegateMultiplexer
      viewInitialized = true
    }
  }
  
  // a multiplexer that provides forwarding
  var delegateMultiplexer: TableViewDelegateMultiplexer {
    return lazyAssociatedProperty(self, &AssociationKey.delegateMultiplex) {
      return TableViewDelegateMultiplexer()
    }
  }
  
  func override_setDelegate(delegate: AnyObject) {
    if !viewInitialized {
      self.override_setDelegate(delegate)
    } else {
      delegateMultiplexer.delegate = delegate
    }
  }
  func override_delegate() -> UITableViewDelegate? {
    if !viewInitialized {
      return self.override_delegate()
    } else {
      // Regardless of what delegate the user specified, we must return the multiplexer
      // as the delegate value. Otherwise the table view will not invoke methods on the multiplexer.
      return delegateMultiplexer
    }
  }
}

extension NSIndexPath {
  convenience init(row: Int) {
    self.init(forRow: row, inSection: 0)
  }
}

// a datasource implementation that renders the data provided by the table view's items property
class TableViewItemsController: ItemsController, UITableViewDataSource, UITableViewDelegate {
  
  let tableView: UITableView
  
  var selectedItemIndex: Int = -1 {
    didSet {
      tableView.selectRowAtIndexPath(NSIndexPath(row: selectedItemIndex), animated: false, scrollPosition: .None)
      if oldValue != selectedItemIndex {
        tableView.deselectRowAtIndexPath(NSIndexPath(row: oldValue), animated: false)
      }
    }
  }
  
  // an observer that is invoked when selection changes, this is used
  // to support two-way binding
  var selectionChangedObserver: ValueChangedNotification?
  
  init(tableView: UITableView) {
    self.tableView = tableView
    
    super.init()
    
    tableView.dataSource = self
    tableView.delegateMultiplexer.proxiedDelegate = self
  }
  
  // MARK: - UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let arrayFacade = arrayFacade {
      return arrayFacade.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let maybeCell: AnyObject? = tableView.dequeueReusableCellWithIdentifier(tableView.cellName)
    if let cell = maybeCell as? UITableViewCell {
      cell.bindingContext = arrayFacade!.itemAtIndex(indexPath.row)
      return cell
    } else {
      ErrorSink.instance.logEvent("ERROR: Unable to dequeque a cell with the name \(tableView.cellName)")
    }
    return UITableViewCell()
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedItemIndex = indexPath.row
    let selectedItem: AnyObject = arrayFacade!.itemAtIndex(indexPath.row)
    if let action = tableView.selectionAction {
      action.execute(selectedItem)
    }
    selectionChangedObserver?(selectedItemIndex)
  }
  
  // MARK: - ItemsController overrides
  
  override func reloadAllItems() {
    tableView.reloadData()
  }
  
  
  override func arrayUpdated(update: ArrayUpdateType) {
    switch update {
    case .ItemAdded(let index, let item):
      tableView.insertRowsAtIndexPaths([NSIndexPath(row: index)], withRowAnimation: .Automatic)
      // re-apply selection
      selectedItemIndex = Int(selectedItemIndex) // fool Swift into invoking didSet ;-)
      break
    case .ItemRemoved(let index, let item):
      tableView.deleteRowsAtIndexPaths([NSIndexPath(row: index)], withRowAnimation: .Automatic)
      // re-apply selection
      selectedItemIndex = Int(selectedItemIndex) // fool Swift into invoking didSet ;-)
      break
    case .ItemUpdated(let index, let item):
      tableView.reloadRowsAtIndexPaths([NSIndexPath(row: index)], withRowAnimation: .Automatic)
      break
    case .Reset:
      reloadAllItems()
      break
    }
  }
  
}


