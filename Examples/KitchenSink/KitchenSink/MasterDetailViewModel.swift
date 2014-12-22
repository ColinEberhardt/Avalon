//
//  MasterDetailViewModel.swift
//  KitchenSink
//
//  Created by Colin Eberhardt on 22/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

class ContactViewModel: NSObject, StringLiteralConvertible {
  dynamic var surname: String = ""
  dynamic var forename: String = ""
  dynamic var age: Int = 0
  
  init(n: String) {
    func trim(s: String) -> String {
      return s.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    let parts = split(n) {$0 == ","}
    forename = parts[0]
    surname = trim(parts[1])
    age = trim(parts[2]).toInt()!
  }
  
  convenience required init(stringLiteral value: String) {
    self.init(n: value)
  }
  
  convenience required init(extendedGraphemeClusterLiteral value: String) {
    self.init(n: value)
  }
  
  convenience required init(unicodeScalarLiteral value: String) {
    self.init(n: value)
  }
}

class MasterDetailViewModel: NSObject {
  
  var contacts: [ContactViewModel] = [ContactViewModel]()
  
  dynamic var selectedContactIndex: Int = 0 {
    didSet {
      selectedContact = contacts[selectedContactIndex]
    }
  }
  
  dynamic var selectedContact: ContactViewModel
  
  override init() {
    
    // populate with some dummy data
    contacts = [
      "Colin, Eberhardt, 39",
      "Jeff, Bridges, 42",
      "Mark, Jones, 66",
      "Jane, Friar, 56"
    ]
    
    
    selectedContact = contacts[0]
      
    super.init()
  }
}
