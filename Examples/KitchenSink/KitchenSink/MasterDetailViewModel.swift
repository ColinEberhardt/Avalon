//
//  MasterDetailViewModel.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 22/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import Avalon

class MasterDetailViewModel: NSObject {
  
  var contacts: ObservableArray
  
  let addNewContactAction: Action!
  
  let endEditingEvent = Event()
  
  dynamic var selectedContactIndex: Int = 0 {
    didSet {
      selectedContact = contacts[selectedContactIndex] as ContactViewModel
      self.endEditingEvent.raiseEvent()
    }
  }
  
  dynamic var selectedContact: ContactViewModel
  
  override init() {
    
    // populate with some dummy data
    self.contacts = [
      ContactViewModel("Colin", "Eberhardt", 39),
      ContactViewModel("Jeff", "Bridges", 42),
      ContactViewModel("Mark", "Jones", 66),
      ContactViewModel("Jane", "Friar", 56)
    ]
    
    selectedContact = contacts[0] as ContactViewModel
      
    super.init()
    
    addNewContactAction = ClosureAction {
      let newContact = ContactViewModel("Forename", "Surname", 0)
      self.contacts.append(newContact)
      self.selectedContactIndex = self.contacts.count - 1
    }
  }
}

class ContactViewModel: NSObject {
  dynamic var surname: String = ""
  dynamic var forename: String = ""
  dynamic var age: Int = 0
  
  init(_ forename: String, _ surname: String, _ age: Int) {
    self.surname = surname
    self.forename = forename
    self.age = age
  }
}
