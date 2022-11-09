//
//  DescriptionCell.swift
//  Hippo
//
//  Created by mochki on 12/6/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {
  
  @IBOutlet weak var descriptionText: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    descriptionText.textColor = themeFontColor()
  }
  
}
