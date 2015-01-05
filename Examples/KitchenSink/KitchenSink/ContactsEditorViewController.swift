//
//  AdvancedMasterDetailViewController.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 05/01/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit
import Avalon

class ContactsEditorViewController: UIViewController {
  
  @IBOutlet weak var contactListTableView: UITableView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var discardChangesButton: UIButton!
  
  override func viewDidLoad() {
    
    contactListTableView.bindings = [
      "contacts" >| "items",
      "selectedContactIndex" |<>| "selectedItemIndex"
    ]
    
    saveButton.bindings = [
      "saveContactAction" >| "action",
      "currentContact.hasUpdates" >| "enabled"
    ]
    
    discardChangesButton.bindings = [
      "discardChangesAction" >| "action",
      "currentContact.hasUpdates" >| "enabled"
    ]
    
    let viewModel = ContactsViewModel()
    
    self.view.bindingContext = viewModel
    
    viewModel.promptToCancelEvent.addHandler(self, handler: ContactsEditorViewController.showContinueEditingPrompt)
  }
  
  func showContinueEditingPrompt(viewModel: ContinueEditingViewModel) {
    let alertController = UIAlertController(title: "Unsaves Changes",
      message: "Do you want to keep your changes and continue editing, or discard them?",
      preferredStyle: .Alert)
    
    let cancelAction = UIAlertAction(title: "Continue Editing", style: .Cancel) {
      (action) in
      viewModel.continueEditing()
    }
    alertController.addAction(cancelAction)
    
    let OKAction = UIAlertAction(title: "Discard Changes", style: .Destructive, handler: nil)
    alertController.addAction(OKAction)
    
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
}