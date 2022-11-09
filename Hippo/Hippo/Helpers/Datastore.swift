//
//  Datastore.swift
//  Hippo
//
//  Created by mochki on 12/12/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import Foundation

func get(url: String, f: (Data) -> Void) {
  guard let url = URL(string: url) else {
    print("Invalid URL")
    return
  }
  
  let req = URLRequest(url: url)
  let semaphore = DispatchSemaphore(value: 0)
  
  var data: Data = Data()
  
  URLSession.shared.dataTask(with: req) { (responseData, _, _) -> Void in
    data = responseData!
    semaphore.signal()
  }.resume()
  
  let _ = semaphore.wait(timeout: .distantFuture)
  
  f(data)
}

func send(url: String, userData: UserData) {
  guard let url = URL(string: url) else {
    print("Invalid URL")
    return
  }
  
  var req = URLRequest(url: url)
  req.httpMethod = "POST"
  req.addValue("application/json", forHTTPHeaderField: "Content-Type")
  let semaphore = DispatchSemaphore(value: 0)

  guard let payload = encodeToJSON(userData: userData) else {
    return
  }
  req.httpBody = payload
  
  URLSession.shared.dataTask(with: req) { (responseData, _, _) -> Void in
    semaphore.signal()
  }.resume()
  
  let _ = semaphore.wait(timeout: .distantFuture)
}



