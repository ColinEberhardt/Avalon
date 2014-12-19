//
//  MemoryLeakViewController.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 17/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import Avalon

class MemoryLeakViewController: UIViewController {
  
  var myEvent = DataEvent<String>()
  
  var str = "foo"
  
  override func viewDidLoad() {
    
    // TODO: Test closure action for retain cycles

    let handler = myEvent.addHandler(self, handler: MemoryLeakViewController.doSomething)
   
    myEvent.raiseEvent("hello")
    myEvent.raiseEvent("with")
    handler.dispose()
    myEvent.raiseEvent("gone")
  }
  
  func doSomething(str: String) {
    println("it happened \(str)")
  }
}