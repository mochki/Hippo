//
//  FileIO.swift
//  Hippo
//
//  Created by mochki on 12/2/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import Foundation

let filemanager = FileManager.default
let documentDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
let fileURL = documentDirectory.appendingPathComponent("userData.json")


// Save our user data to JSON
func saveJSON(encodedJSON: Data) {
  do {
    try encodedJSON.write(to: fileURL)
  } catch {
    print("Error saving user data")
  }
}


// Load our user data from JSON
func loadJSON() -> Data? {
  let JSON: Data?
  do {
     JSON = try Data(contentsOf: fileURL)
  } catch {
    print("Error loading user data")
    return nil
  }
  
  return JSON
}


func loadJSONToString() -> String? {
  let JSON: String?
  do {
    try JSON = String(contentsOf: fileURL)
  } catch {
    print("Error loading user data")
    return nil
  }
  
  return JSON
}
