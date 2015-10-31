//
//  DataContainer.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Foundation
import Timepiece

class DataContainer {
  static var sharedInstance = DataContainer()
  
  var events: [EventEntity] = []
  
  func eventsOnTheDay(date: NSDate) -> [EventEntity] {
    return events.filter() {
      event in
      return event.date.day == date.day
    }
  }
}

func loadTestEvents() {
  let event = EventEntity(name: "Cold shower", date: NSDate(), duration: 75, type: 1, location: nil, isPrivate: true)
  DataContainer.sharedInstance.events.append(event)
}