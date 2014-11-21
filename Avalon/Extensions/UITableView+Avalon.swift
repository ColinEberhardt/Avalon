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
      let source = objc_getAssociatedObject(self, &itemsAssociationKey) as? TableViewSource
      return source != nil ? source!.items : [NSObject]()
    }
    set(newValue) {
      let source = TableViewSource(items: newValue)
      self.dataSource = source
      objc_setAssociatedObject(self, &itemsAssociationKey, source, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
}

private class TableViewSource: NSObject, UITableViewDataSource {
  
  var items: [NSObject]
  
  init(items: [NSObject]) {
    self.items = items
  }
  
  private func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
}
