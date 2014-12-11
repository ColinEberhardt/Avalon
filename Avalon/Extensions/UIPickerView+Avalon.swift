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
  public var items: [String] {
    get {
      return pickerViewSource.items
    }
    set(newValue) {
      pickerViewSource.items = newValue
    }
  }
  
  /// The currently selected item index
  public var selectedItemIndex: Int {
    get {
      return pickerViewSource.selectedItemIndex
    }
    set(newValue) {
      pickerViewSource.selectedItemIndex = newValue
    }
  }
}

// MARK:- Private API 
extension UIPickerView {
  // an accessor for the source that is both the delegate and datasource of the picker view
  var pickerViewSource: PickerViewSource {
    return lazyAssociatedProperty(self, &AssociationKey.tableViewSource) {
      return PickerViewSource(pickerView: self)
    }
  }
}

// MARK:- Delegate forwarding.
extension UIPickerView {
  // subclasses AVDelegateMultiplexer to adopt the UIPickerViewDelegate protocol
  class PickerViewDelegateMultiplexer: AVDelegateMultiplexer, UIPickerViewDelegate {
  }
  
  override func replaceDelegateWithMultiplexer() {
    // replace the delegate with the multiplexer
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
class PickerViewSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
  
  var items: [String] = [String]() {
    didSet {
      pickerView.reloadAllComponents()
      
      // selectedItemIndex might have been bound first, so select now
      pickerView.selectRow(selectedItemIndex, inComponent: 0, animated: true)
    }
  }
  
  var selectedItemIndex: Int = 0 {
    didSet {
      pickerView.selectRow(selectedItemIndex, inComponent: 0, animated: true)
    }
  }
  
  // an observer that is invoked when selection changes, this is used
  // to support two-way binding
  var selectionChangedObserver: (AnyObject->())?

  
  private let pickerView: UIPickerView
  
  init(pickerView: UIPickerView) {
    self.pickerView = pickerView
    
    super.init()
    
    pickerView.delegateMultiplexer.proxiedDelegate = self
    pickerView.dataSource = self
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return items.count
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    return items[row]
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedItemIndex = row
    selectionChangedObserver?(selectedItemIndex)
  }
}