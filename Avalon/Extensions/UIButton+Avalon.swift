//
//  UIButton+Command.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 08/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Public API 
extension UIButton {
  
  /// An bindable button title property
  public var title: String {
    get {
      if let text = self.currentTitle {
        return text
      } else {
        return ""
      }
    }
    set(newValue) {
      self.setTitle(newValue, forState: UIControlState.Normal)
    }
  }
  
  /// An action that is invoked when the button is tapped
  public var action: Action? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.action) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.action, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
      
      // this will get called each time an action is set, but the addTarget implementation ensures
      // that each action is only added once, so repeated calls are ignored
      self.addTarget(self, action: "tapped", forControlEvents: UIControlEvents.TouchUpInside)
    }
  }
  
  func tapped() {
    if let buttonAction = action {
      buttonAction.execute()
    }
  }
}