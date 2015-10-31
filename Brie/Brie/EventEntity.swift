//
//  EventEntity.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Foundation

protocol CalendarEventType { }

func parseToString(hours: Int, minutes: Int) -> String {
  let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
  let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)" 
  return "\(hoursString):\(minutesString)" 
}

class EventEntity: Comparable, CalendarEventType {
  var name: String
  var date: NSDate
  var duration: Int
  
  var durationValue: String {
    let hours = duration / 60
    let minutes = duration % 60
    
    return parseToString(hours, minutes: minutes) 
  }
  
  var type: Int
  var typeValue: CalendarType {
    return CalendarType(rawValue: type)!
  }
  
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
  
  var provider: PopUpProviderType? {
    let value = Int.random(0..<4)
    
    print(value)
    
    if value == 0 {
      return .Iiko
    } else if value == 1 {
      return .Uber
    } else if value == 2 {
      return .KudaGo
    } else {
      return nil
    }
  }
}

func <(lhs: EventEntity, rhs: EventEntity) -> Bool {
  return lhs.date < rhs.date
}

func ==(lhs: EventEntity, rhs: EventEntity) -> Bool {
  return lhs.date == rhs.date
}