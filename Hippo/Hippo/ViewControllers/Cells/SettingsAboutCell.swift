//
//  SettingsAboutCell.swift
//  Hippo
//
//  Created by mochki on 12/7/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import UIKit

class SettingsAboutCell: UITableViewCell {
  
  // MARK: UIComponents
  @IBOutlet weak var aboutLabel: UILabel!
  @IBOutlet weak var aboutText: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    aboutLabel.textColor = themeFontColor()
    aboutText.textColor = themeFontColor()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
