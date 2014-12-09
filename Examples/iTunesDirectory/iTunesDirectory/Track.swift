//
//  Track.swift
//  iTunesDirectory
//
//  Created by Sam Davies on 06/12/2014.
//  Copyright (c) 2014 Avalon. All rights reserved.
//

import Foundation

class Track : NSObject {
  let collectionName: String
  let artworkURL: NSURL
  let details: String
  let title: String
  
  init(collectionName: String, artworkURL: NSURL, details: String, title: String) {
    self.collectionName = collectionName
    self.artworkURL = artworkURL
    self.details = details
    self.title = title
    super.init()
  }
  
  convenience init(dictionary: [String : AnyObject]) {
    let urlString = dictionary["artworkUrl100"] as? String
    let artworkURL = NSURL(string: urlString!)
    
    self.init(collectionName: dictionary["collectionName"]! as String,
                  artworkURL: artworkURL!,
                     details: dictionary["longDescription"]! as String,
                       title: dictionary["trackName"]! as String)
  }
}
