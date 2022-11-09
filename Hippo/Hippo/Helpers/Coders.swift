//
//  Coders.swift
//  Hippo
//
//  Created by mochki on 12/2/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import Foundation

// Encoders
func encodeToJSON(event: Event) -> Data? {
  let JSONData: Data?
  do {
    JSONData = try JSONEncoder().encode(event)
  } catch {
    print("Error encoding event to JSON")
    return nil
  }
  
  return JSONData
}

func encodeToJSON(userData: UserData) -> Data? {
  let JSONData: Data?
  do {
    JSONData = try JSONEncoder().encode(userData)
  } catch {
    print("Error encoding user data to JSON")
    return nil
  }
  
  return JSONData
}

// Decoders
func decodeFromJSON(JSON: Data?) -> Event? {
  let event: Event?
  if JSON == nil { return nil }
  do {
    event = try JSONDecoder().decode(Event.self, from: JSON!)
  } catch {
    print("Error decoded JSON to event")
    return nil
  }
    
  return event
}

func decodeFromJSON(JSON: Data?) -> UserData? {
  let userData: UserData?
  if JSON == nil { return nil }
  do {
    userData = try JSONDecoder().decode(UserData.self, from: JSON!)
  } catch {
    print("Error decoded JSON to event")
    return nil
  }
  
  return userData
}
