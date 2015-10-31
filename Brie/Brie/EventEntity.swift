//
//  EventEntity.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Foundation

protocol CalendarEventType { }

class EventEntity: Comparable, CalendarEventType {
  var name: String
  var date: NSDate
  var duration: Int
  var type: Int
  var location: Location?
  var isPrivate: Bool
  
  init(name: String, date: NSDate, duration: Int, type: Int, location: Location?, isPrivate: Bool) {
    self.name = name
    self.date = date
    self.duration = duration
    self.type = type
    self.location = location
    self.isPrivate = isPrivate
  }
}

func <(lhs: EventEntity, rhs: EventEntity) -> Bool {
  return lhs.date < rhs.date
}

func ==(lhs: EventEntity, rhs: EventEntity) -> Bool {
  return lhs.date == rhs.date
}