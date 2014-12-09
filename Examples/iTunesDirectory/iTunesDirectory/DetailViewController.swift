//
//  DetailViewController.swift
//  iTunesDirectory
//
//  Created by Sam Davies on 06/12/2014.
//  Copyright (c) 2014 Avalon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  var track: Track?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    if let track = track {
      self.view.bindingContext = TrackViewModel(track: track)
    }
  }
}

