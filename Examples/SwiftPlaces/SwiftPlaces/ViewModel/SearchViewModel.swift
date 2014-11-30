//
//  SearchViewModel.swift
//  SwiftPlaces
//
//  Created by Colin Eberhardt on 27/11/2014.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

import Foundation
import Avalon

class SearchViewModel: ViewModelBase {
  
  struct SearchErrorEventData {
    let statusCode: Int
    let error: NSError?
  }
  
  struct PlaceSelectedEventData {
    let place: Place
  }
  
  let searchExecutingEvent = EmptyEvent()
  
  let invalidPostcodeEvent = EmptyEvent()
  
  let searchErrorEvent = Event<SearchErrorEventData>()
  
  let placeSelectedEvent = Event<PlaceSelectedEventData>()
  
  dynamic var searchText = ""
  
  dynamic var places = [Place]()
  
  dynamic var isSearching = false
  
  dynamic lazy var placeSelectedAction: DataAction = {
    ClosureDataAction {
      selectedPlace in
      self.placeSelectedEvent.raiseEvent(PlaceSelectedEventData(place: selectedPlace as Place))
    }
  }()
  
  dynamic lazy var searchAction: Action = {
    ClosureAction {
      
      self.isSearching = true
      
      let postCode = self.searchText
        .stringByTrimmingCharactersInSet(
          NSCharacterSet.whitespaceCharacterSet())
      
      if self.performSearchForPostalCode(postCode) {
        self.searchExecutingEvent.raiseEvent()
      } else {
        self.invalidPostcodeEvent.raiseEvent()
      }
    }
  }()
  
  override init() {
    super.init()
  }
  
  private func performSearchForPostalCode(postalCode: String) -> Bool
  {
    if let parsedPostcode = postalCode.toInt() {
      let url = URLFactory.searchWithPostalCode(postalCode)
      JSONService
        .GET(url)
        .success {
          json in {self.makePlaces(json)} ~> {
            self.places = $0
            self.isSearching = false
          }
        }
        .failure(onFailure, queue: NSOperationQueue.mainQueue())
      return true
    } else {
      return false
    }
  }
  
  
  private func makePlaces(json: AnyObject) -> [Place]
  {
    if let places = BuildPlacesFromJSON(json) as? [Place] {
      if let unique = NSSet(array: places).allObjects as? [Place] {
        return unique.sorted { $0.name < $1.name }
      }
    }
    return []
  }
  
  private func onFailure(statusCode: Int, error: NSError?)
  {
    searchErrorEvent.raiseEvent(SearchErrorEventData(statusCode: statusCode, error: error))
  }
}