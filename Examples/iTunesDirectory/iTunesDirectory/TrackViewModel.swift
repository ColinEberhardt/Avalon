//
//  TrackViewModel.swift
//  iTunesDirectory
//
//  Created by Sam Davies on 06/12/2014.
//  Copyright (c) 2014 Avalon. All rights reserved.
//

import Foundation
import Avalon


class TrackViewModel: ViewModelBase {
  
  dynamic let track: Track
  
  init(track: Track) {
    self.track = track
    super.init()
  }
  
}