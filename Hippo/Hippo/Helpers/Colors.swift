//
//  Colors.swift
//  Hippo
//
//  Created by mochki on 12/5/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import UIKit
import GameplayKit.GKRandomSource

// TODO: Different themes...

fileprivate let fontColor = UIColor(red: 141/255, green: 230/255, blue: 253/255, alpha: 1.0)
fileprivate let placeholderColor = UIColor(red: 141/255, green: 230/255, blue: 253/255, alpha: 0.46)
fileprivate let backgroundColors = [
  UIColor(red: 32/255, green: 45/255, blue: 110/255, alpha: 1.0),
  UIColor(red: 5/255, green: 13/255, blue: 56/255, alpha: 1.0),
  UIColor(red: 14/255, green: 25/255, blue: 85/255, alpha: 1.0),
  UIColor(red: 52/255, green: 64/255, blue: 131/255, alpha: 1.0),
  UIColor(red: 6/255, green: 58/255, blue: 78/255, alpha: 1.0),
  UIColor(red: 22/255, green: 79/255, blue: 101/255, alpha: 1.0),
  UIColor(red: 25/255, green: 29/255, blue: 112/255, alpha: 1.0),
  UIColor(red: 41/255, green: 98/255, blue: 120/255, alpha: 1.0),
  UIColor(red: 1/255, green: 37/255, blue: 51/255, alpha: 1.0),
  UIColor(red: 57/255, green: 29/255, blue: 110/255, alpha: 1.0),
  UIColor(red: 26/255, green: 23/255, blue: 110/255, alpha: 1.0),
  UIColor(red: 14/255, green: 10/255, blue: 84/255, alpha: 1.0),
  UIColor(red: 15/255, green: 59/255, blue: 102/255, alpha: 1.0),
  UIColor(red: 5/255, green: 42/255, blue: 78/255, alpha: 1.0)
]

func themeFontColor() -> UIColor {
  return fontColor
}

func themePlaceholderColor() -> UIColor {
  return placeholderColor
}

func themeBackgroundColors() -> [UIColor] {
  return backgroundColors
}

func shuffledBackgroundColors(ofLength: Int) -> [UIColor] {
  return Array((GKRandomSource.sharedRandom().arrayByShufflingObjects(in: backgroundColors) as! [UIColor]).prefix(ofLength))
}

func blendColors(from: UIColor, to: UIColor, percentage: CGFloat) -> UIColor {
  let fromColor = CIColor(color: from)
  let toColor = CIColor(color: to)
  
  return UIColor(
    red: percentage * (toColor.red - fromColor.red) + fromColor.red,
    green: percentage * (toColor.green - fromColor.green) + fromColor.green,
    blue: percentage * (toColor.blue - fromColor.blue) + fromColor.blue,
    alpha: 1.0
  )
}



