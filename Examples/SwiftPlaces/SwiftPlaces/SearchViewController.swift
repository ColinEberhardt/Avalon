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
    
    // Allow the primary and detail views to show simultaneously.
    splitViewController!.preferredDisplayMode = .AllVisible
    
    // Show an "empty view" on the right-hand side, only on an iPad.
    if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
    {
      let emptyVC = storyboard!.instantiateViewControllerWithIdentifier("EmptyPlaceViewController") as UIViewController
      splitViewController!.showDetailViewController(emptyVC, sender: self)
    }
    
    
    searchBar.bindings = [Binding(source: "searchText", destination: "text", mode: .TwoWay),
      Binding(source: "searchCommand", destination: "searchCommand")]
    
    tableView.bindings = [Binding(source: "places", destination: "items"),
      Binding(source: "placeSelectedCommand", destination: "selectionCommand")]
    
    viewModel = SearchViewModel()
    view.bindingContext = viewModel
    
    viewModel.addEventHandler(SearchViewModel.Events.SearchExecuting) {
      self.searchBar.resignFirstResponder()
      return
    }
    
    viewModel.addEventHandler(SearchViewModel.Events.InvalidPostcode) {
      let image = UIImage(named: "ErrorColor")
      self.searchBar.showErrorMessage("Numbers only!", backgroundImage: image)
    }
    
    viewModel.addPropertyObserver("selectedPlace") {
      if let place = self.viewModel.selectedPlace {
        let placeVC = self.storyboard!.instantiateViewControllerWithIdentifier("PlaceViewController") as PlaceViewController
        placeVC.place = place
        self.showDetailViewController(placeVC, sender: self)
      }
    }
    
    viewModel.addPropertyObserver("isSearching") {
      UIApplication.sharedApplication().networkActivityIndicatorVisible =
        self.viewModel.isSearching
    }
  }
}
