//
//  AppDelegate.swift
//  Hippo
//
//  Created by mochki on 12/1/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var customPageViewController: CustomPageViewController?
  var userData: UserData?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    UIApplication.shared.statusBarStyle = .lightContent
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (permissionGranted, error) in
      print(error as Any)
    }
    
    let notifCategory = UNNotificationCategory(identifier: "reminders", actions: [], intentIdentifiers: [], options: [])
    UNUserNotificationCenter.current().setNotificationCategories([notifCategory])
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if userData?.name != nil && userData?.events?.count != nil {
      saveJSON(encodedJSON: encodeToJSON(userData: userData!)!)
      send(url: "https://us-central1-hippo-185304.cloudfunctions.net/pushData", userData: userData!)
    }
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
  }

  func mountUserDataIntoAppDelegate(userData: UserData) {
    self.userData = userData
  }

}

