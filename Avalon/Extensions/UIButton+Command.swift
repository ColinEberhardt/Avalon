//
//  UIButton+Command.swift
//  MvvmSwift
//
//  Created by Colin Eberhardt on 08/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

private var commandAssociationKey: UInt8 = 5

extension UIButton {
  
  var command: Command? {
    get {
      return objc_getAssociatedObject(self, &commandAssociationKey) as Command?
    }
    set(newValue) {
      objc_setAssociatedObject(self, &commandAssociationKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
      
      // TODO: Ensure this is a one-time subscription
      self.addTarget(self, action: "tapped", forControlEvents: UIControlEvents.TouchUpInside)
    }
  }
  
  func tapped() {
    if let buttonCommand = command {
      buttonCommand.execute()
    }
  }
}