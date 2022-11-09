//
//
//  NewEventViewController.swift
//  Hippo
//
//  Created by mochki on 12/6/17.
//  Copyright © 2017 mochki. All rights reserved.


import UIKit

class NewEventViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: - Properties
  var parentPVC = CustomPageViewController()
  var userIDButtonLabel = UIButton()
  var userData: UserData? = nil
  var timeCell = NewEventOptionCell()
  var notificationCell = NewEventOptionCell()
  var pairingCell = NewEventOptionCell()
  var descriptionCell = NewEventDescriptionCell()
//  var appendEventToParent: ((Event) -> Void)? = nil
  
  // MARK: - UIComponents
  @IBOutlet weak var keepTrackOfLabel: UILabel!
  @IBOutlet weak var newEventTitle: UITextField!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  @IBOutlet weak var scrollView: UIScrollView!
  
  
  // MARK: - Lifecycle Hooks
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    keepTrackOfLabel.textColor = themeFontColor()
    newEventTitle.attributedPlaceholder = NSAttributedString(string: getSampleEvent(), attributes: [NSAttributedStringKey.foregroundColor: themePlaceholderColor()])
    newEventTitle.textColor = themeFontColor()
    newEventTitle.autocapitalizationType = .words
    newEventTitle.autocorrectionType = .no
    newEventTitle.keyboardAppearance = .dark
    newEventTitle.returnKeyType = .done
    newEventTitle.delegate = self
    
    scrollView.delegate = self
    
    saveButton.setTitleColor(themeFontColor(), for: .normal)
    // Idk if this works
    //    newEventTitle.attributedPlaceholder = NSAttributedString(string: getSampleEvent(), attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: themePlaceholderColor()])
    tableView.delegate = self
    tableView.allowsSelection = false
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    newEventTitle.becomeFirstResponder()
  }
  
  func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.view.endEditing(true)
    descriptionCell.forceEndEditing()
  }
  
  
  // MARK: Action Handler
  
  @IBAction func didInitSave(_ sender: Any) {
    if !(newEventTitle.text?.isEmpty)! {
//      var date = Date()
//      if timeCell.optionValueButton.currentTitle! != "select date" {
//        // but casted
//      }
      
      var options = [String:String]()
      if notificationCell.optionValueButton.currentTitle != "off" {
        options["notificationCycle"] = notificationCell.optionValueButton.currentTitle
      }
      
      if pairingCell.optionValueButton.currentTitle != "pair" {
        options["hardwarePaired"] = pairingCell.optionValueButton.currentTitle
      }
      
      if descriptionCell.descriptionTextField.text != "" {
        options["description"] = descriptionCell.descriptionTextField.text!
      }
      
      let newEvent = Event(name: newEventTitle.text!, firstTime: Date(), options: options)
      
      parentPVC.appendNewEvent(newEvent!)
    }
  }
  
  
  // MARK: UITableView
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      let cell: NewEventOptionCell = tableView.dequeueReusableCell(withIdentifier: "newEventOptionCell", for: indexPath) as! NewEventOptionCell
      cell.optionTitle.text = "First Time"
      cell.optionValueButton.setTitle("today", for: .normal)
      cell.optionValueButton.isUserInteractionEnabled = false
//      cell.optionValueButton.setTitle("select date", for: .normal)
      timeCell = cell
      return cell
    case 1:
      let cell: NewEventOptionCell = tableView.dequeueReusableCell(withIdentifier: "newEventOptionCell", for: indexPath) as! NewEventOptionCell
      cell.optionTitle.text = "Notifications"
      cell.optionValueButton.setTitle("off", for: .normal)
      cell.type = "notifications"
      notificationCell = cell
      return cell
    case 2:
      let cell: NewEventOptionCell = tableView.dequeueReusableCell(withIdentifier: "newEventOptionCell", for: indexPath) as! NewEventOptionCell
      cell.optionTitle.text = "Hardware paired"
      cell.optionValueButton.setTitle("pair", for: .normal)
      cell.type = "pairing"
      pairingCell = cell
      return cell
    case 3:
      let cell: NewEventDescriptionCell = tableView.dequeueReusableCell(withIdentifier: "newEventDescriptionCell", for: indexPath) as! NewEventDescriptionCell
      cell.descriptionLabel.text = "Description"
      descriptionCell = cell
      return cell
    default:
      return UITableViewCell()
    }
  }
}

