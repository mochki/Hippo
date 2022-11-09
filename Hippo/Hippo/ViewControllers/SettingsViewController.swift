//
//
//  SettingsViewController.swift
//  Hippo
//
//  Created by mochki on 12/6/17.
//  Copyright © 2017 mochki. All rights reserved.


import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: - Properties
  var userIDButtonLabel = UIButton()
  var userData: UserData? = nil
  
  // MARK: - UIComponents
  @IBOutlet weak var helloLabel: UILabel!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  @IBOutlet weak var scrollView: UIScrollView!
  
  
  // MARK: - Lifecycle Hooks
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    helloLabel.textColor = themeFontColor()
    nameTextField.attributedPlaceholder = NSAttributedString(string: getSampleName(), attributes: [NSAttributedStringKey.foregroundColor: themePlaceholderColor()])
    nameTextField.textColor = themeFontColor()
    nameTextField.autocapitalizationType = .words
    nameTextField.autocorrectionType = .no
    nameTextField.keyboardAppearance = .dark
    nameTextField.returnKeyType = .done
    nameTextField.delegate = self

    if userData?.name != nil { nameTextField.text = userData?.name }
    scrollView.delegate = self
    
    tableView.delegate = self
    tableView.allowsSelection = false
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    nameTextField.becomeFirstResponder()
  }
  
  func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
    self.view.endEditing(true)
    if !(scoreText.text?.isEmpty)! {
      let name = scoreText.text
      userData?.name = name
      userData?.username = spinalCase(name!)
      userIDButtonLabel.setTitle(spinalCase(name!), for: .normal)
    } else {
      userIDButtonLabel.setTitle("first-lastname", for: .normal)
    }
    
    return true
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    // TODO: Add a thing where we reset the text field. 
    self.view.endEditing(true)
  }
  
  
  // MARK: UITableView
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell: SettingsOptionCell = tableView.dequeueReusableCell(withIdentifier: "settingsOptionCell", for: indexPath) as! SettingsOptionCell
      cell.optionTitle.text = "Theme"
      cell.optionValueButton.setTitle("blue", for: .normal)
      return cell
    case 1:
      let cell: SettingsOptionCell = tableView.dequeueReusableCell(withIdentifier: "settingsOptionCell", for: indexPath) as! SettingsOptionCell
      cell.optionTitle.text = "User Identifier"
      if userData?.name != nil {
        cell.optionValueButton.setTitle(userData?.username, for: .normal)
      } else {
        cell.optionValueButton.setTitle("first-lastname", for: .normal)
      }
      userIDButtonLabel = cell.optionValueButton
      return cell
    case 2:
      let cell: SettingsAboutCell = tableView.dequeueReusableCell(withIdentifier: "settingsAboutCell", for: indexPath) as! SettingsAboutCell
      cell.aboutLabel.text = "About"
      cell.aboutText.text = "I have this fascination with Hippos. I think they're super cute. Also, the hippocampus is a part of the brain that helps short term memory become long term memory. Since I'm always forgetting the last time I put new contacts in or the last time I got an oil change, I made this app to keep track of and remember all these things for me. Thanks Hippo."
      return cell
    default:
      return UITableViewCell()
    }
  }

}
