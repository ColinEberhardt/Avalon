//
//  Threading.swift
//  Avalon
//
//  Created by Colin Eberhardt on 18/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// executes the given function on the main thread
func executeOnMainThread<T>(fn: () -> T?) -> T? {
  if !NSThread.isMainThread() {
    // if we are not on the main thread, queue this function
    NSOperationQueue.mainQueue().addOperationWithBlock {
      fn()
      return
    }
    // we cannot return the function result, so return nil
    return nil
  } else {
    return fn()
  }
}

// executes the given function on the main thread
func executeOnMainThread(fn: () -> ()) {
  if !NSThread.isMainThread() {
    // if we are not on the main thread, queue this function
    NSOperationQueue.mainQueue().addOperationWithBlock {
      fn()
      return
    }
  } else {
    fn()
  }
}