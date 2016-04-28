//
//  AppDelegate.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit
import UberKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var shortcutItem: UIApplicationShortcutItem?
  
  func createNewItem() {
    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
    let newItemVC = storyBoard.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
    window?.rootViewController?.navigationController?.presentViewController(newItemVC, animated: true, completion: nil)
  }
  
  func findLocalEvents() {
    let entity = SpaceEntity(date: NSDate(), duration: 60)
    (window?.rootViewController as? CalendarViewController)?.showEvents(entity)
  }
  
  func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
    var succeeded = false
    if shortcutItem.type == "com.vadimandalex.brie.add-item" {
      createNewItem()
      succeeded = true
    } else if shortcutItem.type == "com.vadimandalex.brie.find-events" {
      findLocalEvents()
      succeeded = true
    }
    return succeeded
  }
  
  func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
    completionHandler(handleShortcut(shortcutItem))
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    print(url)
    print(sourceApplication)

    if sourceApplication != nil {
      VKSdk.processOpenURL(url, fromApplication: sourceApplication)
      UberKit.sharedInstance().redirectURL = "action"
      UberKit.sharedInstance().handleLoginRedirectFromUrl(url, sourceApplication: sourceApplication)
    }
    return true
  }
    
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    //loadTestEvents()
    
    UberAuth.setUp()
    var performShortcutDelegate = true
    
    if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
      print("Application launched via shortcut")
      self.shortcutItem = shortcutItem
      performShortcutDelegate = false
    }
    
    return performShortcutDelegate
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    guard let shortcut = shortcutItem else { return }
    handleShortcut(shortcut)
    self.shortcutItem = nil
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

