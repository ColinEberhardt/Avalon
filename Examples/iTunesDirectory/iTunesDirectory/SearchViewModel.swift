//
//  SearchViewModel.swift
//  iTunesDirectory
//
//  Created by Sam Davies on 06/12/2014.
//  Copyright (c) 2014 Avalon. All rights reserved.
//

import Foundation
import Avalon

class SearchViewModel : ViewModelBase {
  
  var sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
  lazy var session: NSURLSession = {
    return NSURLSession(configuration: self.sessionConfig)
  }()
  
  struct SearchErrorEventData {
    let statusCode: Int
    let error: NSError?
  }
  struct TrackSelectedEventData {
    let track: Track
  }
  
  let searchExecutingEvent = Event()
  let searchErrorEvent = DataEvent<SearchErrorEventData>()
  let trackSelectedEvent = DataEvent<TrackSelectedEventData>()
  
  dynamic var searchString = ""
  dynamic var tracks = [Track]()
  dynamic var isSearching = false
  
  dynamic lazy var trackSelectedAction: DataAction = {
    ClosureDataAction {
      selectedTrack in
      self.trackSelectedEvent.raiseEvent(TrackSelectedEventData(track: selectedTrack as Track))
    }
  }()
  
  dynamic lazy var searchAction: Action = {
    ClosureAction {
      self.isSearching = true
      self.performSearchWithString(self.searchString)
    }
  }()
  
  
  private func performSearchWithString(term: String) {
    let encodedTerm = term.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    let url = NSURL(string: "https://itunes.apple.com/search?term=\(encodedTerm)&media=tvShow")!
    let dataTask = session.dataTaskWithURL(url) {
      (data, response, error) in
      
      if error == nil {
        let http = response as NSHTTPURLResponse
        if http.statusCode == 200 {
          self.processResults(data)
          self.isSearching = false
        } else {
          self.searchErrorEvent.raiseEvent(SearchErrorEventData(statusCode: http.statusCode, error: error))
        }
      } else {
        self.searchErrorEvent.raiseEvent(SearchErrorEventData(statusCode: 0, error: error))
      }
    }
    dataTask.resume()
  }
  
  private func processResults(data: NSData) {
    var error: NSError?
    if let json = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &error) as? NSDictionary {
      if let results = json["results"] as? [[String : AnyObject]] {
        let t = results.map { Track(dictionary: $0) }
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.tracks = t
        }
      }
    } else {
      self.searchErrorEvent.raiseEvent(SearchErrorEventData(statusCode: 0, error: error))
    }
  }
}