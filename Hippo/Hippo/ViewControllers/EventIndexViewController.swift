//
//  EventIndexViewController.swift
//  Hippo
//
//  Created by mochki on 12/2/17.
//  Copyright © 2017 mochki. All rights reserved.
//
//  TODO:
//  - Seperate month and day in View so they're seperate, cleaner columns

import UIKit
import UserNotifications

class EventIndexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: Properties
  
  var event: Event? = nil
  var years: [Int] = []
  var titles: [String] = []
  var timeData: [[[String:String]]] = []
  var optionCells: [OptionCell] = []
  var updated = false
  let notificationContent = UNMutableNotificationContent()
  let notificationTrigger: UNTimeIntervalNotificationTrigger? = nil
  var notificationIdentifier = ""
  
  
  // MARK: UI Components

  @IBOutlet weak var eventTitle: UILabel!
  @IBOutlet weak var timeSinceTagline: UILabel!
  @IBOutlet weak var updateButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  // TODO: Might be unnecessary, maybe delete and edit in storyboard
  @IBOutlet weak var scrollView: UIScrollView!
  
  
  // MARK: Lifecycle Hooks
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
      var found = false
      for req in requests {
        if req.identifier == "\((self.event?.name)!)Identifier" {
          found = true
        }
      }
      if !found && self.event?.notificationCycle != nil && self.event?.notificationCycle != "none" {
        self.createNotification(timeInterval: (self.event?.notificationCycle)!)
      }
    }
    
    eventTitle.text = event?.name
    eventTitle.textColor = themeFontColor()
    timeSinceTagline.text = toTimeSinceTagline(now: Date(), since: event!.history[0])
    timeSinceTagline.textColor = .white
    updateButton.setTitleColor(themeFontColor(), for: .normal)
    tableView.delegate = self
    tableView.backgroundColor = .clear
    tableView.allowsSelection = false
    
    notificationContent.title = (event?.name)!
    notificationContent.body  = "Just a friendly reminder"
    notificationContent.categoryIdentifier = "reminders"
    notificationIdentifier = "\((event?.name)!)Identifier"
    
    prepDataForPresentation()
    
    tableView.reloadData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableViewHeight.constant = tableView.contentSize.height
    self.view.layoutIfNeeded()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    for cell in optionCells {
      cell.addModal()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    for cell in optionCells {
      cell.removeModal()
    }
  }
  
  
  // MARK: Class Helpers
  
  func prepDataForPresentation() {
    // This could be more efficient
    years = returnYears(history: (event?.history)!)
    titles = years.sorted { $0 > $1 }.map { "\($0) Track Record" } + ["Options", "Description"]
  }
  
  func createNotification(timeInterval: String) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    let timer: UNTimeIntervalNotificationTrigger
    switch timeInterval {
    case "none":
      return
    case "daily":
      timer = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)
      UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: timer) , withCompletionHandler: nil)
    case "weekly":
      timer = UNTimeIntervalNotificationTrigger(timeInterval: 604800, repeats: true)
      UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: timer) , withCompletionHandler: nil)
    case "bi-weekly":
      timer = UNTimeIntervalNotificationTrigger(timeInterval: 1209600, repeats: true)
      UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: timer) , withCompletionHandler: nil)
    case "monthly":
      timer = UNTimeIntervalNotificationTrigger(timeInterval: 2592000, repeats: true)
      UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: timer) , withCompletionHandler: nil)
    case "quarterly":
      timer = UNTimeIntervalNotificationTrigger(timeInterval: 7884000, repeats: true)
      UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: timer) , withCompletionHandler: nil)
    case "semi-annually":
      timer = UNTimeIntervalNotificationTrigger(timeInterval: 15768000, repeats: true)
      UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: timer) , withCompletionHandler: nil)
    case "annually":
      timer = UNTimeIntervalNotificationTrigger(timeInterval: 31536000, repeats: true)
      UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: timer) , withCompletionHandler: nil)
    default:
      return
    }
  }
  
  
  // MARK: UI Actions Handlers

  @IBAction func updateHistory(_ sender: Any) {
    updated = true
    event?.history.insert(Date(), at: 0)
    prepDataForPresentation()
    timeSinceTagline.text = toTimeSinceTagline(now: Date(), since: event!.history[0])
    if event?.notificationCycle != nil {
      createNotification(timeInterval: (event?.notificationCycle)!)
    }
    tableView.reloadData()
    viewDidLayoutSubviews()
  }
  
  
  // MARK: UITableView
  
  // Section Headers
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2 + years.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    // Needed even though we re-set it in willDisplayHeaderView
    if titles.count == 0 { return nil }
    return titles[section]
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.text = titles[section]
    header.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
    header.textLabel?.textColor = themeFontColor()
  }
  
  // Rows
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case titles.count - 1:
      return 1
    case titles.count - 2:
      return 2
    default:
      // such a weirld place to call this
      timeData = prepareDatesForTableView(history: (event?.history)!)
      return timeData[section].count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case titles.count - 1:
      let cell: DescriptionCell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! DescriptionCell
      if let descrp = event?.description {
        cell.descriptionText.text = descrp
      } else {
        cell.descriptionText.text = "No description is given"
      }
      return cell
      
    case titles.count - 2:
      let cell: OptionCell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as! OptionCell
      cell.parentEvent = event
      cell.parentVC = self
      switch indexPath.row {
      case 0:
        cell.optionLabel.text = "Notifications"
        cell.type = "notifications"
        if let notif = event?.notificationCycle {
          cell.optionValue.setTitle(notif, for: .normal)
        } else {
          cell.optionValue.setTitle("add", for: .normal)
        }
      case 1:
        cell.optionLabel.text = "Hardware paired"
        cell.type = "pairing"
        if let MAC = event?.hardwarePaired {
          cell.optionValue.setTitle(MAC, for: .normal)
        } else {
          cell.optionValue.setTitle("not paired", for: .normal)
        }
      default:
        cell.optionLabel.text = "_______________"
        cell.optionValue.setTitle("___", for: .normal)
      }
      if !updated {
        optionCells.append(cell)
      }
      return cell
      
    default:
      let cell: DateCell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
      cell.dateLabel.text = timeData[indexPath.section][indexPath.row]["date"]
      cell.timeGapLabel.text = timeData[indexPath.section][indexPath.row]["timeGap"]
      return cell
    }

  }
}


extension EventIndexViewController: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
  }
}

