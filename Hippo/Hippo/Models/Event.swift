//
//  Event.swift
//  Hippo
//
//  Created by mochki on 12/2/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import Foundation

class Event: Codable {
  
  // MARK - Properties
  
  var name: String
  var description: String?
  var history: [Date]
  var shortOrLong: String        // Defaults to short
  var notificationCycle: String? // Defaults to nil, Handle serverside (?)
  var hardwarePaired: String?    // Defaults to nil, MAC Address of Amazon Dash
  
  // MARK - Initializers
  
  // Simplest
  init?(name: String, firstTime history: Date) {
    self.name = name
    self.history = [history]
    self.shortOrLong = "short"
  }
  
  // Options
  convenience init?(name: String, firstTime history: Date, options: [String:String]) {
    self.init(name: name, firstTime: history)
    self.name = name
    self.history = [history]
    
    if let description = options["description"] { self.description = description }
    if let notificationCycle = options["notificationCycle"] { self.notificationCycle = notificationCycle }
    if let shortOrLong = options["shortOrLong"] { self.shortOrLong = shortOrLong }
    if let hardwarePaired = options["hardwarePaired"] { self.hardwarePaired = hardwarePaired }
  }

}
