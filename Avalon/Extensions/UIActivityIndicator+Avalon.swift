//
//  UIActivityIndicator+Bindable.swift
//  Avalon
//
//  Created by Colin Eberhardt on 14/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
  
  /// An bindable animating property
  public var animating: Bool {
    get {
      return self.isAnimating()
    }
    set(newValue) {
      if newValue {
        self.startAnimating()
      } else {
        self.stopAnimating()
      }
    }
  }
}