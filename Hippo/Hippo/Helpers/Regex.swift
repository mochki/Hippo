//
//  Regex.swift
//  Hippo
//
//  Created by mochki on 12/10/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import Foundation

func regexMatches(regex: String, in text: String) -> [String] {
  do {
    let regex = try NSRegularExpression(pattern: regex)
    let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
    return results.map {
      String(text[Range($0.range, in: text)!])
    }
  } catch let error {
    print("invalid regex: \(error.localizedDescription)")
    return []
  }
}
