//
//  UIButton+Command.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 08/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
  
  func override_didMoveToWindow() {
    // perform a one-time subscription to the tager action for the button
    self.addTarget(self, action: "tapped", forControlEvents: UIControlEvents.TouchUpInside)
    self.override_didMoveToWindow()
  }
  
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
  
  public var action: Action? {
    get {
      return objc_getAssociatedObject(self, &AssociationKey.action) as Action?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociationKey.action, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
    }
  }
  
  func tapped() {
    if let buttonAction = action {
      buttonAction.execute()
    }
  }
}