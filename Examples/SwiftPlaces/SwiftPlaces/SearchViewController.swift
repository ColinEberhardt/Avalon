//
//  ViewController.swift
//  SwiftPlaces
//
//  Created by Joshua Smith on 7/25/14.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

import UIKit
import Avalon

/** Shows a search bar and lists places found by postal code. */
class SearchViewController: UIViewController
{
  @IBOutlet private weak var searchBar: UISearchBar!
  @IBOutlet private weak var tableView: UITableView!
  
  private var viewModel: SearchViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Search"
    
    // Configure the UI
    splitViewController!.preferredDisplayMode = .AllVisible
    
    if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
    {
      let emptyVC = storyboard!.instantiateViewControllerWithIdentifier("EmptyPlaceViewController") as UIViewController
      splitViewController!.showDetailViewController(emptyVC, sender: self)
    }
    
    // bind the controls to the view model
    searchBar.bindings = [Binding(source: "searchText", destination: "text", mode: .TwoWay),
      Binding(source: "searchAction", destination: "searchAction")]
    
    tableView.bindings = [Binding(source: "places", destination: "items"),
      Binding(source: "placeSelectedAction", destination: "selectionAction")]
    
    viewModel = SearchViewModel()
    view.bindingContext = viewModel
    
    // handle events form the view model
    viewModel.searchExecutingEvent.addHandler(self, SearchViewController.hideKeyboard)
    viewModel.searchErrorEvent.addHandler(self, SearchViewController.showAlert)
    viewModel.invalidPostcodeEvent.addHandler(self, SearchViewController.showTextInputError)
    viewModel.placeSelectedEvent.addHandler(self, SearchViewController.navigateToPlaceViewController)
    
    // observe view model property changes
    viewModel.addPropertyObserver(["isSearching"], self, SearchViewController.viewModelPropertyChanged)
  }
  
  func viewModelPropertyChanged(propertyName: String) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible =
      viewModel.isSearching
  }
  
  func navigateToPlaceViewController(placeEventData: PlaceSelectedEventData) {
    let placeVC = self.storyboard!.instantiateViewControllerWithIdentifier("PlaceViewController") as PlaceViewController
    placeVC.place = placeEventData.place
    showDetailViewController(placeVC, sender: self)
  }
  
  func showTextInputError() {
    let image = UIImage(named: "ErrorColor")
    searchBar.showErrorMessage("Numbers only!", backgroundImage: image)
  }
  
  func hideKeyboard() {
    searchBar.resignFirstResponder()
    return
  }
  
  func showAlert(errorData: SearchErrorEventData) {
    let title = "Error"
    let msg   = errorData.error?.localizedDescription ?? "An error occurred."
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
    
    alert.addAction(UIAlertAction( title: "OK", style: .Default, handler: { _ in
      self.dismissViewControllerAnimated(true, completion: nil)
    }))
    
    presentViewController(alert, animated: true, completion: nil)
  }
}
