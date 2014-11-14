//
//  ViewController.swift
//  Swift Weather
//
//  Created by Jake Lin on 4/06/2014.
//  Copyright (c) 2014 rushjet. All rights reserved.
//

import UIKit
import Avalon

class BoolInvertConverter: ValueConverter {
  override func convert(sourceValue: AnyObject, binding: Binding, viewModel: AnyObject) -> AnyObject? {
    return !(sourceValue as Bool)
  }
}

class ViewController: UIViewController {
    
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadingIndicator.bindings = [Binding(source: "loading", destination: "animating"),
      Binding(source: "loading", destination: "hidden", converter: BoolInvertConverter())]
    
    let background = UIImage(named: "background.png")
    self.view.backgroundColor = UIColor(patternImage: background!)
    
    self.view.bindingContext = SwiftWeatherViewModel()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
    
    /*
    iOS 8 Utility
    */
    /*func ios8() -> Bool {
        if ( NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 ) {
            return false
        } else {
            return true
        }
    }
    
    //CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count-1] as CLLocation
        
        if (location.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            println(location.coordinate)
            updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
        self.loading.text = "Can't get your location!"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }*/
}
