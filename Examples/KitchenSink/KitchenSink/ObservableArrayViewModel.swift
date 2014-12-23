//
//  ObservableArrayViewModel.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 16/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import Avalon

class ObservableArrayViewModel: ViewModelBase {
  
  dynamic var items: ObservableArray = ["one", "two", "three"]
  
  dynamic var item = "new"
  
  dynamic var itemIndex: Int = 0 {
    didSet {
      update()
    }
  }
  
  dynamic var selectedItemIndex = 0
  
  dynamic var maxIndex = 0
  
  dynamic let addItemAction: Action!
  
  dynamic let removeItemAction: Action!
  
  dynamic let removeAllItemsAction: Action!
  
  dynamic let clearSelectionAction: Action!
  
  dynamic var removeItemActionEnabled: Bool = true
  
  override init() {
    super.init()
    
    update()
    
    addItemAction =  ClosureAction {
      self.items.insert(self.item, atIndex: self.itemIndex)
      self.update()
    }
    
    clearSelectionAction = ClosureAction {
      self.selectedItemIndex = -1
    }
    
    removeItemAction = ClosureAction {
      self.items.removeAtIndex(self.itemIndex)
      self.update()
    }
    
    removeAllItemsAction = ClosureAction {
      self.items.removeAll()
      self.update()
    }
  }
  
  func update() {
    maxIndex = items.count
    removeItemActionEnabled = itemIndex < maxIndex
  }
}