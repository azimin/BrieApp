//
//  DataContainer.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Foundation
import Timepiece

private let eventsKey = "eventsKey1"

class DataContainer {
  static var sharedInstance = DataContainer()
  
  var events: [EventEntity] = {
    return DataContainer.load()
  }()
  
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
}

func loadTestEvents() {
  let event = EventEntity(name: "Cold shower", date: NSDate(), duration: 75, type: 1, location: nil, isPrivate: true)
  DataContainer.sharedInstance.events.append(event)
}