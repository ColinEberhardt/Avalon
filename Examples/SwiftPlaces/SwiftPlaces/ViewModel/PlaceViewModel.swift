//
//  PlaceViewModerl.swift
//  SwiftPlaces
//
//  Created by Colin Eberhardt on 27/11/2014.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

import Foundation
import Avalon

class PlaceViewModel: ViewModelBase {
  
  dynamic let place: Place
  dynamic var weather: Weather?
  
  init(place: Place) {
    self.place = place
    
    super.init()
    
    fetchWeather()
  }
  
  private func fetchWeather() {
    let lat = place.latitude
    let lng = place.longitude
    let url = URLFactory.weatherAtLatitude(lat, longitude: lng)
    
    JSONService
      .GET(url)
      .success{json in self.weather = BuildWeatherFromJSON(json)}
      .failure(onFailure)
  }
  
  private func onFailure(statusCode: Int, error: NSError?)
  {
    println("HTTP status code \(statusCode) Error: \(error)")
    
    // TODO: How do we accomplish this?
   // self.weatherLabel.text = "unavailable"
  }
}
