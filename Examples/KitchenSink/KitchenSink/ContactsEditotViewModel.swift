//
//  AdvancedMasterDetailViewModel.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 05/01/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import Foundation
import Avalon

class ContinueEditingViewModel: NSObject {
  private let parent: ContactsViewModel
  private let adaptedContact: ContactEditorViewModel
  
  init(parent: ContactsViewModel, adaptedContact: ContactEditorViewModel) {
    self.parent = parent
    self.adaptedContact = adaptedContact
  }
  
  func continueEditing() {
    parent.reInstate(adaptedContact)
  }
}

class ContactsViewModel: NSObject {
  
  var contacts: ObservableArray
  
  let saveContactAction: Action!
  
  let discardChangesAction: Action!
  
  dynamic var saveContactActionEnabled = false
  
  let promptToCancelEvent = DataEvent<ContinueEditingViewModel>()
  
  private var isUpdating = false
  
  dynamic var selectedContactIndex: Int = 0 {
    didSet {
      if (isUpdating) {
        return
      }
      if currentContact.hasUpdates {
        let c = ContinueEditingViewModel(parent: self, adaptedContact: currentContact)
        promptToCancelEvent.raiseEvent(c)
      }
      
      let selectedContact = contacts[selectedContactIndex] as ContactModel
      currentContact = ContactEditorViewModel(selectedContact, selectedContactIndex)
    }
  }
  
  dynamic var currentContact: ContactEditorViewModel
  
  override init() {
    
    // populate with some dummy data
    self.contacts = [
      ContactModel("Colin", "Eberhardt", 39),
      ContactModel("Jeff", "Bridges", 42),
      ContactModel("Mark", "Jones", 66),
      ContactModel("Jane", "Friar", 56)
    ]
    
    let selectedContact = contacts[0] as ContactModel
    currentContact = ContactEditorViewModel(selectedContact, 0)
    
    super.init()
    
    saveContactAction = ClosureAction {
      self.currentContact.saveChanges()
    }
    
    discardChangesAction = ClosureAction {
      self.currentContact.discardChanges()
    }
  }
  
  private func reInstate(viewModel: ContactEditorViewModel) {
    isUpdating = true
    selectedContactIndex = viewModel.index
    currentContact = viewModel
    isUpdating = false
  }
}

//MARK: - the underlying model object
class ContactModel: NSObject {
  dynamic var surname: String = ""
  dynamic var forename: String = ""
  dynamic var age: Int = 0
  
  init(_ forename: String, _ surname: String, _ age: Int) {
    self.surname = surname
    self.forename = forename
    self.age = age
  }
}

//MARK: - a view model that adapts a contact model object to allow editing.
class ContactEditorViewModel: NSObject {
  dynamic var surname: String = "" {
    didSet {
      hasUpdates = true
    }
  }
  
  dynamic var forename: String = "" {
    didSet {
      hasUpdates = true
    }
  }
  dynamic var age: Int = 1 {
    didSet {
      hasUpdates = true
    }
  }
  
  dynamic var hasUpdates = false
  
  let contactModel: ContactModel
  let index: Int
  
  init(_ model: ContactModel, _ index: Int) {
    self.contactModel = model
    self.index = index
    
    super.init()
    
    copyModelToViewModel()
    hasUpdates = false
  }
  
  func saveChanges() {
    copyViewModelToModel()
    hasUpdates = false
  }
  
  func discardChanges() {
    copyModelToViewModel()
    hasUpdates = false
  }
  
  private func copyModelToViewModel() {
    self.surname = contactModel.surname
    self.forename = contactModel.forename
    self.age = contactModel.age
  }
  
  private func copyViewModelToModel() {
    contactModel.surname = self.surname
    contactModel.forename = self.forename
    contactModel.age = self.age
  }
}