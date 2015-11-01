//
//  DataContainer.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Foundation
import Timepiece
import SwiftyJSON

private let eventsKey = "eventsKey1"

class DataContainer {
  static var sharedInstance = DataContainer()
  
  var events: [EventEntity] = {
    return DataContainer.load()
    }() {
    didSet {
      save()
      saveNote(events.last?.name ?? "")
    }
  }
  
  func eventsOnTheDay(date: NSDate) -> [EventEntity] {
    return events.filter() {
      event in
      return event.date.day == date.day
    }
  }
  
  static func load() -> [EventEntity] {
    if let data = NSUserDefaults.standardUserDefaults().objectForKey(eventsKey) as? NSData  {
      return NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [EventEntity]
    }
    return []
  }
  
  func save() {
    NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(events), forKey: eventsKey)
  }
  
  func saveNote(name: String) {
    VKSdk.initializeWithDelegate(DataContainerVkDelegateHolder(), andAppId: "5128197")
    if VKSdk.wakeUpSession() {
      print("AUTHORIZED AND READY TO GO")
      let request = VKAuth.changeNoteTitleToName(name)
      request.executeWithResultBlock({ (response) -> Void in
        
        }, errorBlock: { (error) -> Void in
          
      })
    } else {
      print("LET'S AUTHORIZE")
      VKAuthtorize()
    }
  }
  
  func getNoteTitle(completion: (String?) -> ()) {
    VKSdk.initializeWithDelegate(DataContainerVkDelegateHolder(), andAppId: "5128197")
    if VKSdk.wakeUpSession() {
      let request = VKAuth.getNotesByURL()
      request.executeWithResultBlock({ (response) -> Void in
        if let resp = JSON(response.json).dictionary {
          let text = resp["items"]?.arrayValue[0].dictionaryValue["title"] ?? ""
          completion(text.string)
        }
        }) { (error) -> Void in
          print(error)
          completion(nil)
      }
    } else {
      print("LET'S AUTHORIZE")
      VKAuthtorize()
    }
  }
  
  let idsOfFriends = [
    8796171,
    33399749,
    10731954,
    212846399,
    140382302,
    21273568
  ] // FOR TEST ONLY
  
  func VKAuthtorize() {
    VKSdk.authorize([VK_PER_OFFLINE, VK_PER_WALL, VK_PER_FRIENDS, VK_PER_NOTES], revokeAccess: true)
  }
}

class DataContainerVkDelegateHolder: NSObject, VKSdkDelegate {
  func vkSdkNeedCaptchaEnter(captchaError: VKError) {
    print("Need captcha")
  }
  
  func vkSdkTokenHasExpired(expiredToken: VKAccessToken) {
    print("Token has exp")
  }
  
  func vkSdkUserDeniedAccess(authorizationError: VKError) {
    print("Access denied")
  }
  
  func vkSdkShouldPresentViewController(controller: UIViewController) {
    print("Should present VC")
    (UIApplication.sharedApplication().delegate as! AppDelegate).window!.rootViewController!.presentViewController(controller, animated: true) { () -> Void in
      print("Success!")
    }
  }
  
  func vkSdkReceivedNewToken(newToken: VKAccessToken) {
    print("Succesfully authorized! User ID:")
    print(VKSdk.getAccessToken().userId)
  }
}

func loadTestEvents() {
  let event = EventEntity(name: "Cold shower", date: NSDate(), duration: 75, type: 1, location: nil, isPrivate: true)
  DataContainer.sharedInstance.events.append(event)
}