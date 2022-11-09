//
//  CustomPageViewController.swift
//  Hippo
//
//  Created by mochki on 12/1/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import UIKit

class CustomPageViewController: UIPageViewController {
  
  // MARK: Globals
  
  let UISB = UIStoryboard(name: "Main", bundle: nil)
  var userData: UserData? = nil
  var backgrounds: [UIColor] = []
  var pageIndex: Int = 0
  
  // MARK: Properties
  
  var orderedViewControllers: [UIViewController] = []
  
  
  // MARK: Lifecycle Hooks
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataSource = self
    delegate = self as? UIPageViewControllerDelegate
    
    let scrollview = view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView
    scrollview.delegate = self
    
    get(url: "https://us-central1-hippo-185304.cloudfunctions.net/retrieveData") { (data) in
      if let tempData: UserData = decodeFromJSON(JSON: data)  {
        userData = tempData
        for event in (userData?.events!)! {
          orderedViewControllers.append(newEventIndex(event))
        }
      } else {
        if let uData: UserData = decodeFromJSON(JSON: loadJSON()) {
          userData = uData
          for event in uData.events! {
            orderedViewControllers.append(newEventIndex(event))
          }
        } else {
          userData = UserData(name: nil, events: [])
          for event in (userData?.events!)! {
            orderedViewControllers.append(newEventIndex(event))
          }
        }
      }
    }
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.mountUserDataIntoAppDelegate(userData: userData!)
    
    // Add New Event and Settings View Controlllers
    let newEventView = UISB.instantiateViewController(withIdentifier: "NewEvent") as! NewEventViewController
    newEventView.parentPVC = self
    newEventView.userData = userData
    orderedViewControllers.append(newEventView)
    let settingsView = UISB.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
    settingsView.userData = userData
    orderedViewControllers.append(settingsView)
    
    // Finally, create the backgrounds
    backgrounds = shuffledBackgroundColors(ofLength: orderedViewControllers.count)
    self.view.backgroundColor = backgrounds[pageIndex]
    
    if let firstViewController = orderedViewControllers.first {
      setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
  }
  
  
  // MARK: Helper Methods
  
  private func newEventIndex(_ event: Event) -> EventIndexViewController {
    let newEventIndex = UISB.instantiateViewController(withIdentifier: "EventIndex") as! EventIndexViewController
    newEventIndex.event = event
    
    return newEventIndex
  }
  
  func appendNewEvent(_ event: Event) {
    userData?.events?.insert(event, at: 0)
    saveJSON(encodedJSON: encodeToJSON(userData: userData!)!)
    send(url: "https://us-central1-hippo-185304.cloudfunctions.net/pushData", userData: userData!)
    // I fell so very very bad about this.
    UIApplication.shared.keyWindow!.rootViewController = storyboard?.instantiateInitialViewController()
  }
  
}



// MARK: UIScrollViewDelegate

extension CustomPageViewController: UIScrollViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let frameWidth = scrollView.frame.size.width
    var offset = scrollView.contentOffset.x
    if offset == frameWidth {
      // Set actual background here
      self.view.backgroundColor = backgrounds[pageIndex]
      return
    }
    
    if offset > frameWidth {
      // Next Color
      offset -= frameWidth
      if pageIndex == orderedViewControllers.count - 1 {
        self.view.backgroundColor = blendColors(from: backgrounds[pageIndex], to: .black, percentage: offset/frameWidth)
      } else {
        self.view.backgroundColor = blendColors(from: backgrounds[pageIndex], to: backgrounds[pageIndex + 1], percentage: offset/frameWidth)
      }
    } else {
      // Previous Color
      offset = frameWidth - offset
      if pageIndex == 0 {
        self.view.backgroundColor = blendColors(from: backgrounds[pageIndex], to: .black, percentage: offset/frameWidth)
      } else {
        self.view.backgroundColor = blendColors(from: backgrounds[pageIndex], to: backgrounds[pageIndex - 1], percentage: offset/frameWidth)
      }
    }
  }
  
}



// MARK: UIPageViewControllerDataSource

extension CustomPageViewController: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
      return nil
    }
    
    pageIndex = viewControllerIndex
    let previousIndex = viewControllerIndex - 1
    guard previousIndex >= 0 else { return nil }
    guard previousIndex <= orderedViewControllers.count else { return nil }
  
    return orderedViewControllers[previousIndex]
  }
  
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
      return nil
    }
    
    pageIndex = viewControllerIndex
    let nextIndex = viewControllerIndex + 1
    let viewControllerMax = orderedViewControllers.count
    guard nextIndex != viewControllerMax else { return nil }
    guard nextIndex <  viewControllerMax else { return nil }
    
    return orderedViewControllers[nextIndex]
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return orderedViewControllers.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let firstViewController = viewControllers?.first,
      let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
        return 1
    }
    
    return firstViewControllerIndex
  }
}
