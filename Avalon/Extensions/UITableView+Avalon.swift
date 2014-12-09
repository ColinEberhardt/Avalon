//
//  UITableView+Avalon.swift
//  Avalon
//
//  Created by Colin Eberhardt on 17/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  
  public var items: [NSObject] {
    get {
      return tableViewSource.items
    }
    set(newValue) {
      tableViewSource.items = newValue
    }
  }
  
  public var selectionAction: DataAction? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.action) as DataAction?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.action, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
}

// subclasses AVDelegateMultiplexer to adopt the UITableViewDelegate protocol
class TableViewDelegateMultiplexer: AVDelegateMultiplexer, UITableViewDelegate {
}

extension UITableView {
  var tableViewSource: TableViewSource {
    return lazyAssociatedProperty(self, &AssociationKey.tableViewSource) {
      return TableViewSource(tableView: self)
    }
  }
  
  // funny things happen if the delegate is switched before the table view renders
  // for this reason the switch occurs when didMoveToWindow is invoked.
  func override_didMoveToWindow() {
    // replace the delegate with the multiplexer
    if delegate !== delegateMultiplexer {
      delegateMultiplexer.delegate = delegate
      self.delegate = delegateMultiplexer
    }
    
    
    tableViewInitialized = true
    
    self.override_didMoveToWindow()
  }
  
  // a multiplexer that provides forwarding
  var delegateMultiplexer: TableViewDelegateMultiplexer {
    return lazyAssociatedProperty(self, &AssociationKey.delegateMultiplex) {
      return TableViewDelegateMultiplexer()
    }
  }
  
  // an associated boolean property that is set to true when didMoveToWindow occurs
  var tableViewInitialized: Bool {
    get {
      let tableViewInitialized = objc_getAssociatedObject(self, &AssociationKey.tableViewInitialized) as Bool?
      if let tableViewInitialized = tableViewInitialized {
        return tableViewInitialized
      }
      return false
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.tableViewInitialized, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  func override_setDelegate(delegate: AnyObject) {
    if !tableViewInitialized {
      self.override_setDelegate(delegate)
    } else {
      delegateMultiplexer.delegate = delegate
    }
  }
  func override_delegate() -> UITableViewDelegate? {
    if !tableViewInitialized {
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
