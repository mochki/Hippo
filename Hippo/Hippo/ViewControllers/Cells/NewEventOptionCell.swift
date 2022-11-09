//
//  NewEventOptionCell.swift
//  Hippo
//
//  Created by mochki on 12/7/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import UIKit

class NewEventOptionCell: UITableViewCell {
  
  // MARK: Properties
  var appWindow: UIWindow = UIWindow()
  var modal = UIView()
  var showModal = false
  let modalHeight: CGFloat = 230
  var type: String = ""
  var initLoad = true
  
  // Type specific
  let notificationData = ["none", "daily", "weekly", "bi-weekly", "monthly", "quarterly", "semi-annually", "annually"]
  let notificationPicker = UIPickerView()
  let pairingInput = UITextField()
  
  // MARK: UIComponents
  @IBOutlet weak var optionTitle: UILabel!
  @IBOutlet weak var optionValueButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    optionTitle.textColor = themeFontColor()
    optionValueButton.setTitleColor(themeFontColor(), for: .normal)
    
    // Modals
    appWindow = UIApplication.shared.keyWindow!
    addModal()
  }

  @IBAction func didInitChange(_ sender: Any) {
    if showModal {
      animateHideModal()
    } else {
      animateShowModal()
    }
    
    showModal = !showModal
  }
  
  func addModal() {
    modal = UIView(frame: CGRect(x: appWindow.frame.origin.x, y: appWindow.frame.height, width: appWindow.frame.width, height: modalHeight))
    let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateHideModal))
    swipe.direction = .down
    modal.addGestureRecognizer(swipe)
    appWindow.addSubview(modal)
    
    let blurEffect = UIBlurEffect(style: .dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = modal.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    modal.addSubview(blurEffectView)
  }
  
  func removeModal() {
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.modal.frame = CGRect(x: self.appWindow.frame.origin.x, y: self.appWindow.frame.height, width: self.appWindow.frame.width, height: self.modalHeight)
    }) { (true) in
      self.showModal = false
      self.modal.removeFromSuperview()
    }
  }
  
  // MARK: Action Handlers
  
  @objc func donePressed() {
    if type == "pairing" {
      self.pairingInput.endEditing(true)
    }
    animateHideModal()
  }
  
  // MARK: Helper functions
  
  func animateShowModal() {
    if initLoad {
      if type == "notifications" {
        notificationPicker.delegate = self
        notificationPicker.dataSource = self
        notificationPicker.frame = modal.bounds
        modal.addSubview(notificationPicker)
      } else if type == "pairing" {
        pairingInput.delegate = self
        pairingInput.frame = CGRect(x: 10, y: 100, width: modal.frame.width - 20, height: 30)
        pairingInput.textAlignment = .center
        pairingInput.attributedPlaceholder = NSAttributedString(string: "Enter MAC Address here", attributes: [NSAttributedStringKey.foregroundColor: themePlaceholderColor()])
        pairingInput.textColor = themeFontColor()
        pairingInput.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        pairingInput.autocorrectionType = .no
        pairingInput.keyboardAppearance = .dark
        pairingInput.returnKeyType = .done
        modal.addSubview(pairingInput)
        // Blah blah blah
      }
      
      let doneButton = UIButton(type: .system)
      doneButton.setTitle("Done", for: .normal)
      doneButton.setTitleColor(themeFontColor(), for: .normal)
      doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
      doneButton.sizeToFit()
      doneButton.frame.origin.x = modal.frame.width - (20 + doneButton.frame.size.width)
      doneButton.frame.origin.y = 10
      doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
      modal.addSubview(doneButton)
      initLoad = false
    }
    
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.modal.frame = CGRect(x: self.appWindow.frame.origin.x, y: self.appWindow.frame.height - self.modalHeight, width: self.appWindow.frame.width, height: self.modalHeight)
    }, completion: nil)
  }
  
  @objc func animateHideModal() {
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.modal.frame = CGRect(x: self.appWindow.frame.origin.x, y: self.appWindow.frame.height, width: self.appWindow.frame.width, height: self.modalHeight)
    }, completion: nil)
  }
}


extension NewEventOptionCell: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return notificationData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    return NSAttributedString(string: notificationData[row], attributes: [.foregroundColor: themeFontColor()])
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    // TODO:
    //
    // MAKE THE CALL TO SEND NOTIFICATION HERE
    //
    optionValueButton.setTitle(notificationData[row], for: .normal)
  }
}

extension NewEventOptionCell: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.modal.frame = self.modal.frame.offsetBy(dx: 0, dy: -140)
    }, completion: nil)
  }
  
  func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.modal.frame = self.modal.frame.offsetBy(dx: 0, dy: 140)
    }, completion: nil)
    self.pairingInput.endEditing(true)
    
    let matches = regexMatches(regex: "((?:[0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2})", in: scoreText.text!)
    if matches.count > 0 {
      scoreText.text = matches[0]
      optionValueButton.setTitle(matches[0], for: .normal)
    } else {
      scoreText.text = ""
    }
    
    return true
  }
  
}



