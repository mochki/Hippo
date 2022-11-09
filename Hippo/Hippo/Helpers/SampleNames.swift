//
//  SampleNames.swift
//  Hippo
//
//  Created by mochki on 12/7/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import Foundation

fileprivate let sampleNames = ["Boniqua", "Kyle", "Tati", "Gambino", "Sun Fun Guy"]

func getSampleName() -> String {
  return sampleNames[random(sampleNames.count)]
}
