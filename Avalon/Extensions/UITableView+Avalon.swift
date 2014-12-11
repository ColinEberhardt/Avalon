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
  public var items: [NSObject] {
    get {
      return tableViewSource.items
    }
    set(newValue) {
      tableViewSource.items = newValue
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
}


// MARK:- Private API
extension UITableView {
  // an accessor for the source that implemented both the delegate and datasource
  var tableViewSource: TableViewSource {
    return lazyAssociatedProperty(self, &AssociationKey.tableViewSource) {
      return TableViewSource(tableView: self)
    }
  }
}

// MARK:- Delegate forwarding.
extension UITableView {
  // subclasses AVDelegateMultiplexer to adopt the UITableViewDelegate protocol
  class TableViewDelegateMultiplexer: AVDelegateMultiplexer, UITableViewDelegate {
  }
  
  override func replaceDelegateWithMultiplexer() {
    // replace the delegate with the multiplexer
    delegateMultiplexer.delegate = self.delegate
    self.delegate = delegateMultiplexer
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

// a datasource implementation that renders the data provided by the table view's items property
class TableViewSource: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  var items: [NSObject] = [NSObject]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  let tableView: UITableView
  
  init(tableView: UITableView) {
    self.tableView = tableView
    
    super.init()
    
    tableView.dataSource = self
    tableView.delegateMultiplexer.proxiedDelegate = self
  }
  
  // MARK: - UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // TODO: How do we inform the tableview of the cell name?
    let maybeCell: AnyObject? = tableView.dequeueReusableCellWithIdentifier("Cell")
    if let cell = maybeCell as? UITableViewCell {
      cell.bindingContext = items[indexPath.row]
      return cell
    }
    return UITableViewCell()
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let selectedItem: AnyObject = items[indexPath.row]
    if let action = tableView.selectionAction {
      action.execute(selectedItem)
    }
  }
}
