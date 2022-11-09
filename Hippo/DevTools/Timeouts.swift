//
//  Timeouts.swift
//  http://peatiscoding.me/uncategorized/javascript-settimeout-swift-3-0/
//
//
//

import Foundation

func setTimeout(_ delay:TimeInterval, block:@escaping ()->Void) -> Timer {
  return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
}

func setInterval(_ interval:TimeInterval, block:@escaping ()->Void) -> Timer {
  return Timer.scheduledTimer(timeInterval: interval, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: true)
}

// Usage
// let handle = setTimeout(0.35, block: { () -> Void in
//   // do this stuff after 0.35 seconds
// })
//
// // Later on cancel it
// handle.invalidate()

