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
    
    viewModel.searchExecutingEvent += {
      self.searchBar.resignFirstResponder()
      return
    }
    
    viewModel.searchErrorEvent += {
      errorData in
      let title = "Error"
      let msg   = errorData.error?.localizedDescription ?? "An error occurred."
      let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
      
      alert.addAction(UIAlertAction( title: "OK", style: .Default, handler: { _ in
        self.dismissViewControllerAnimated(true, completion: nil)
      }))
      
      self.presentViewController(alert, animated: true, completion: nil)
    }
    
    viewModel.invalidPostcodeEvent += {
      let image = UIImage(named: "ErrorColor")
      self.searchBar.showErrorMessage("Numbers only!", backgroundImage: image)
    }
    
    viewModel.placeSelectedEvent += {
      placeEventData in
      let placeVC = self.storyboard!.instantiateViewControllerWithIdentifier("PlaceViewController") as PlaceViewController
      placeVC.place = placeEventData.place
      self.showDetailViewController(placeVC, sender: self)
    }
    
    viewModel.addPropertyObserver("isSearching") {
      UIApplication.sharedApplication().networkActivityIndicatorVisible =
        self.viewModel.isSearching
    }
  }
}
