//
//  Random.swift
//  Hippo
//
//  Created by mochki on 12/6/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import Foundation

func random(_ n: Int) -> Int {
  return Int(arc4random_uniform(UInt32(n)))
}
