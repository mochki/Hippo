//
//  SampleEvents.swift
//  Hippo
//
//  Created by mochki on 12/7/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import Foundation

fileprivate let sampleEvent = ["Tripping", "Nose Picking", "Breathing", "Cauliflower", "Diarrhea"]

func getSampleEvent() -> String {
  return sampleEvent[random(sampleEvent.count)]
}
