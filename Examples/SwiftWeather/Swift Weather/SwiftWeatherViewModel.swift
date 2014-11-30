//
//  SwiftWeatherViewModel.swift
//  Swift Weather
//
//  Created by Colin Eberhardt on 14/11/2014.
//  Copyright (c) 2014 rushjet. All rights reserved.
//

import Foundation
import CoreLocation
import Avalon

class SwiftWeatherViewModel: NSObject, CLLocationManagerDelegate {
  
  private let locationManager = CLLocationManager()
  
  dynamic var loading = true
  dynamic var loadingText = "Loading..."
  dynamic var temperature = ""
  dynamic var location = ""
  dynamic var iconImage: UIImage?
  dynamic let tappedAction: Action!
  
  override init() {
    super.init()
    
    tappedAction = ClosureAction {
      self.locationManager.startUpdatingLocation()
    }
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
  }
  
  //CLLocationManagerDelegate
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    let location = locations[locations.count - 1] as CLLocation
    
    if location.horizontalAccuracy > 0 {
      locationManager.stopUpdatingLocation()
      updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
  }
  
  func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    loadingText = "Can't get your location!"
  }
  
  private func updateWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let manager = AFHTTPRequestOperationManager()
    let url = "http://api.openweathermap.org/data/2.5/weather"
    println(url)
    
    let params = ["lat":latitude, "lon":longitude, "cnt":0]
    println(params)
    
    manager.GET(url,
      parameters: params,
      success: {
        (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
        println("JSON: " + responseObject.description!)
        
        self.updateUISuccess(responseObject as NSDictionary!)
      },
      failure: {
        (operation: AFHTTPRequestOperation!, error: NSError!) in
        println("Error: " + error.localizedDescription)
        
        self.loadingText = "Internet appears down!"
    })
  }
  
  private func updateUISuccess(jsonResult: NSDictionary!) {
    loadingText = ""
    loading = false
    
    if let tempResult = ((jsonResult["main"]? as NSDictionary)["temp"] as? Double) {
      
      // If we can get the temperature from JSON correctly, we assume the rest of JSON is correct.
      var temp: Double
      if let sys = (jsonResult["sys"]? as? NSDictionary) {
        if let country = (sys["country"] as? String) {
          if (country == "US") {
            // Convert temperature to Fahrenheit if user is within the US
            temp = round(((tempResult - 273.15) * 1.8) + 32)
          }
          else {
            // Otherwise, convert temperature to Celsius
            temp = round(tempResult - 273.15)
          }
          
          temperature = "\(temp)°"
        }
        
        if let name = jsonResult["name"] as? String {
          location = name
        }
        
        if let weather = jsonResult["weather"]? as? NSArray {
          var condition = (weather[0] as NSDictionary)["id"] as Int
          var sunrise = sys["sunrise"] as Double
          var sunset = sys["sunset"] as Double
          
          var nightTime = false
          var now = NSDate().timeIntervalSince1970
          
          if (now < sunrise || now > sunset) {
            nightTime = true
          }
          self.updateWeatherIcon(condition, nightTime: nightTime)
          return
        }
      }
    }
    loadingText = "Weather info is not available!"
  }
  
  // Converts a Weather Condition into one of our icons.
  // Refer to: http://bugs.openweathermap.org/projects/api/wiki/Weather_Condition_Codes
  private func updateWeatherIcon(condition: Int, nightTime: Bool) {
    // Thunderstorm
    if (condition < 300) {
      if nightTime {
        iconImage = UIImage(named: "tstorm1_night")
      } else {
        iconImage = UIImage(named: "tstorm1")
      }
    }
      // Drizzle
    else if (condition < 500) {
      iconImage = UIImage(named: "light_rain")
    }
      // Rain / Freezing rain / Shower rain
    else if (condition < 600) {
      iconImage = UIImage(named: "shower3")
    }
      // Snow
    else if (condition < 700) {
      iconImage = UIImage(named: "snow4")
    }
      // Fog / Mist / Haze / etc.
    else if (condition < 771) {
      if nightTime {
        iconImage = UIImage(named: "fog_night")
      } else {
        iconImage = UIImage(named: "fog")
      }
    }
      // Tornado / Squalls
    else if (condition < 800) {
      iconImage = UIImage(named: "tstorm3")
    }
      // Sky is clear
    else if (condition == 800) {
      if (nightTime){
        iconImage = UIImage(named: "sunny_night") // sunny night?
      }
      else {
        iconImage = UIImage(named: "sunny")
      }
    }
      // few / scattered / broken clouds
    else if (condition < 804) {
      if (nightTime){
        iconImage = UIImage(named: "cloudy2_night")
      }
      else{
        iconImage = UIImage(named: "cloudy2")
      }
    }
      // overcast clouds
    else if (condition == 804) {
      iconImage = UIImage(named: "overcast")
    }
      // Extreme
    else if ((condition >= 900 && condition < 903) || (condition > 904 && condition < 1000)) {
      iconImage = UIImage(named: "tstorm3")
    }
      // Cold
    else if (condition == 903) {
      iconImage = UIImage(named: "snow5")
    }
      // Hot
    else if (condition == 904) {
      iconImage = UIImage(named: "sunny")
    }
      // Weather condition is not available
    else {
      iconImage = UIImage(named: "dunno")
    }
  }
  
  
}