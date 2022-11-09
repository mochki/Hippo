//
//  SettingsOptionCell.swift
//  Hippo
//
//  Created by mochki on 12/7/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import UIKit

class SettingsOptionCell: UITableViewCell {
  
  // MARK: UIComponents
  @IBOutlet weak var optionTitle: UILabel!
  @IBOutlet weak var optionValueButton: UIButton!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    optionTitle.textColor = themeFontColor()
    optionValueButton.setTitleColor(themeFontColor(), for: .normal)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
