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
  
  struct Events {
    static let SearchExecuting = "searchExecuted"
    static let InvalidPostcode = "invalidPostcode"
  }
  
  dynamic var searchText = ""
  
  dynamic var places = [Place]()
  
  dynamic var isSearching = false
  
  dynamic var selectedPlace: Place?
  
  dynamic lazy var placeSelectedCommand: DataCommand = {
    ClosureDataCommand {
      selectedPlace in
      self.selectedPlace = (selectedPlace as Place)
    }
  }()
  
  dynamic lazy var searchCommand: Command = {
    ClosureCommand {
      
      self.isSearching = true
      
      let postCode = self.searchText
        .stringByTrimmingCharactersInSet(
          NSCharacterSet.whitespaceCharacterSet())
      
      if self.performSearchForPostalCode(postCode) {
        self.raiseEvent(Events.SearchExecuting)
      } else {
        self.raiseEvent(Events.InvalidPostcode)
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
    println("HTTP status code \(statusCode)")
    
    /*let
    title = "Error",
    msg   = error?.localizedDescription ?? "An error occurred.",
    alert = UIAlertController(
      title: title,
      message: msg,
      preferredStyle: .Alert)
    
    alert.addAction(UIAlertAction(
      title: "OK",
      style: .Default,
      handler: { _ in
        self.dismissViewControllerAnimated(true, completion: nil)
    }))
    
    presentViewController(alert, animated: true, completion: nil)*/
  }
}