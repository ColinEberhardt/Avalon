//
//  SearchViewModel.swift
//  SwiftPlaces
//
//  Created by Colin Eberhardt on 27/11/2014.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

import Foundation
import Avalon

struct SearchErrorEventData {
  let statusCode: Int
  let error: NSError?
}

struct PlaceSelectedEventData {
  let place: Place
}

class SearchViewModel: ViewModelBase {
  
  let searchExecutingEvent = Event()
  
  let invalidPostcodeEvent = Event()
  
  let searchErrorEvent = DataEvent<SearchErrorEventData>()
  
  let placeSelectedEvent = DataEvent<PlaceSelectedEventData>()
  
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
          json in
          self.places = self.makePlaces(json)
          self.isSearching = false
        }
        .failure(onFailure)
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