//
//  MasterViewController.swift
//  iTunesDirectory
//
//  Created by Sam Davies on 06/12/2014.
//  Copyright (c) 2014 Avalon. All rights reserved.
//

import UIKit
import Avalon

class MasterViewController: UITableViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  private var viewModel: SearchViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // bind the controls to the view model
    searchBar.bindings = ["searchString" |<>| "text",
                          "searchAction"   >| "searchAction"]
    
    tableView.bindings = ["tracks"              >| "items",
                          "trackSelectedAction" >| "selectionAction"]
    
    
    viewModel = SearchViewModel()
    view.bindingContext = viewModel
    
    // handle events form the view model
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
    
    viewModel.trackSelectedEvent += {
      trackEventData in
      println(trackEventData)
    }
    
    viewModel.addPropertyObserver("isSearching") {
      UIApplication.sharedApplication().networkActivityIndicatorVisible =
        self.viewModel.isSearching
    }

    
  }
}

