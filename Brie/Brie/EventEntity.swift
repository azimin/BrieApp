//
//  EventEntity.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Foundation

protocol CalendarEventType { }

extension NSDate {
    func getDayInt() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: self)
        return components.day
    }

    func getMonthInt() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: self)
        return components.month
    }
    
    func getYearInt() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: self)
        return components.year
    }
    
    func createDate(hour: Int) -> NSDate {
        return NSDate.from(year: self.getYearInt(), month: self.getMonthInt(), day: self.getDayInt(), hour: hour)
    }
    
    class func from(year year: Int, month: Int, day: Int, hour: Int) -> NSDate {
        let c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = hour
        
        let gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        let date = gregorian!.dateFromComponents(c)
        return date!
    }
    
    func novemberize() -> String {
        return "\(self.getDayInt()) \(self.getMonth())"
    }
    
    func hoursFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).hour
    }
    
    func increaseByHours(hours: Int) -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(
            .Hour,
            value: hours,
            toDate: self,
            options: NSCalendarOptions(rawValue: 0))!
    }
    
  func hoursFrom(date: NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).hour
  }
  
  func increaseByHours(hours: Int) -> NSDate {
    return NSCalendar.currentCalendar().dateByAddingUnit(
      .Hour,
      value: hours,
      toDate: self,
      options: NSCalendarOptions(rawValue: 0))!
  }
}

func parseToString(hours: Int, minutes: Int) -> String {
  let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
  let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)" 
  return "\(hoursString):\(minutesString)" 

}

class SpaceEntity: CalendarEventType, Comparable {
    var date: NSDate
    var duration: Int
    
    init(date: NSDate, duration: Int) {
        self.date = date
        self.duration = duration
    }
    
    class func findSpacesBetweenEvents(var events: [EventEntity]) -> [CalendarEventType] {
        var results = [CalendarEventType]()
        events.sortInPlace()
      
        for i in 1..<events.count {
            let spaceSize = (events[i].date.hoursFrom(events[i - 1].date)) - (events[i].duration) * 60 // Размер промежутка в часах между двумя датами
            if spaceSize > 1 {
                results.append(SpaceEntity(date: events[i - 1].date.increaseByHours(events[i - 1].duration), duration: spaceSize))
            }
        }
        return results
    }
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
  var locationValue: String {
    return location == nil ? "Location not selected" : location?.name ?? location?.address ?? "Location"
  }
  
  
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

func <(lhs: SpaceEntity, rhs: SpaceEntity) -> Bool {
    return lhs.date < rhs.date
}

func ==(lhs: SpaceEntity, rhs: SpaceEntity) -> Bool {
    return lhs.date == rhs.date
}

func <(lhs: EventEntity, rhs: EventEntity) -> Bool {
  return lhs.date < rhs.date
}

func ==(lhs: EventEntity, rhs: EventEntity) -> Bool {
  return lhs.date == rhs.date
}