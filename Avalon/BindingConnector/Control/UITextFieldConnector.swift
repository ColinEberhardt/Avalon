//
//  TextFieldConnector.swift
//  Avalon
//
//  Created by Colin Eberhardt on 11/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

class UITextFieldControlConnector: UIControlBindingConnector {
  
  init?(source: NSObject, textField: UITextField, binding: Binding) {
    super.init(source: source, destination: textField, valueExtractor: { textField.text }, binding: binding, events: UIControlEvents.EditingChanged)
    
    if binding.destinationProperty != "text" {
      ErrorSink.instance.logEvent("ERROR: view \(textField) does not support two-way binding, with binding \(binding)");
      return nil
    }
  }
}