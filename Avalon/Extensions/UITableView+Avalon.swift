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
      let source = objc_getAssociatedObject(self, &AssociationKey.items) as? TableViewSource
      return source != nil ? source!.items : [NSObject]()
    }
    set(newValue) {
      let source = TableViewSource(tableView: self, items: newValue)
      objc_setAssociatedObject(self, &AssociationKey.items, source, UInt(OBJC_ASSOCIATION_RETAIN))
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

private class TableViewSource: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  var items: [NSObject]
  let tableView: UITableView
  
  init(tableView: UITableView, items: [NSObject]) {
    self.items = items
    self.tableView = tableView
    
    super.init()
    
    tableView.dataSource = self
    // TODO: provide delegate forwarding so that the user can still use this controls delegate
    tableView.delegate = self
    
    tableView.reloadData()
  }
  
  // MARK: - UITableViewDataSource
  
  private func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // TODO: How do we inform the tableview of the cell name?
    let maybeCell: AnyObject? = tableView.dequeueReusableCellWithIdentifier("Cell")
    if let cell = maybeCell as? UITableViewCell {
      cell.bindingContext = items[indexPath.row]
      return cell
    }
    return UITableViewCell()
  }
  
  // MARK: - UITableViewDelegate
  
  private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let selectedItem: AnyObject = items[indexPath.row]
    if let action = tableView.selectionAction {
      action.execute(selectedItem)
    }
  }
}
