//
//  UIPickerView+Avalon.swift
//  Avalon
//
//  Created by Colin Eberhardt on 10/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// MARK:- Public API
extension UIPickerView {
  
  /// An bindable array of strings that represent the picker items
  public var items: AnyObject? {
    get {
      return itemsController.items
    }
    set(newValue) {
      itemsController.items = newValue
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
}

// MARK:- Private API 
extension UIPickerView {
  // an accessor for the controller that handles updating the segmented control
  var itemsController: PickerViewItemsController {
    return lazyAssociatedProperty(self, &AssociationKey.itemsController) {
      return PickerViewItemsController(pickerView: self)
    }
  }
}

// MARK:- Delegate forwarding.
extension UIPickerView {
  // subclasses AVDelegateMultiplexer to adopt the UIPickerViewDelegate protocol
  class PickerViewDelegateMultiplexer: AVDelegateMultiplexer, UIPickerViewDelegate {
  }
  
  public override func didMoveToWindow() {
    // replace the delegate with the multiplexer
    if (!viewInitialized) {
      delegateMultiplexer.delegate = self.delegate
      self.delegate = delegateMultiplexer
      viewInitialized = true
    }
  }
  
  func replaceDelegateWithMultiplexer() {
    delegateMultiplexer.delegate = self.delegate
    self.delegate = delegateMultiplexer
  }
  
  // a multiplexer that provides forwarding
  var delegateMultiplexer: PickerViewDelegateMultiplexer {
    return lazyAssociatedProperty(self, &AssociationKey.delegateMultiplex) {
      return PickerViewDelegateMultiplexer()
    }
  }
  
  func override_setDelegate(delegate: AnyObject) {
    if !viewInitialized {
      self.override_setDelegate(delegate)
    } else {
      delegateMultiplexer.delegate = delegate
    }
  }
  func override_delegate() -> UIPickerViewDelegate? {
    if !viewInitialized {
      return self.override_delegate()
    } else {
      // Regardless of what delegate the user specified, we must return the multiplexer
      // as the delegate value. Otherwise the table view will not invoke methods on the multiplexer.
      return delegateMultiplexer
    }
  }
}


// a datasource implementation that renders the data provided by the picker view's items property
class PickerViewItemsController: ItemsController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  var selectedItemIndex: Int = 0 {
    didSet {
      pickerView.selectRow(selectedItemIndex, inComponent: 0, animated: true)
    }
  }
  
  // an observer that is invoked when selection changes, this is used
  // to support two-way binding
  var selectionChangedObserver: (ValueChangedNotification)?
  
  private let pickerView: UIPickerView
  
  init(pickerView: UIPickerView) {
    self.pickerView = pickerView
    
    super.init()
    
    pickerView.delegateMultiplexer.proxiedDelegate = self
    pickerView.dataSource = self
  }
  
  // MARK:- UIPickerViewDataSource
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if let arrayFacade = arrayFacade {
      return arrayFacade.count
    } else {
      return 0
    }
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    if let title = arrayFacade!.itemAtIndex(row) as? String {
      return title
    } else {
      ErrorSink.instance.logEvent("ERROR: An array of items that are not strings has been bound to a picker view. Only arrays of strings are supported.")
      return ""
    }
  }
  
  // MARK:- UIPickerViewDelegate
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedItemIndex = row
    selectionChangedObserver?(selectedItemIndex)
  }
  
  // MARK:- ItemsController overrides
  
  override func reloadAllItems() {
    pickerView.reloadAllComponents()
  }
  
  override func arrayUpdated(update: ArrayUpdateType) {
    // picker views do not support insertion / removal of rows. The only
    // options is a complete update
    pickerView.reloadAllComponents()
  }
}