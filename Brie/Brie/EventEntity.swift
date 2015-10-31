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
    
//  func hoursFrom(date: NSDate) -> Int{
//    return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).hour
//  }
//  
//  func increaseByHours(hours: Int) -> NSDate {
//    return NSCalendar.currentCalendar().dateByAddingUnit(
//      .Hour,
//      value: hours,
//      toDate: self,
//      options: NSCalendarOptions(rawValue: 0))!
//  }
}

func twoSimbols(value: Int) -> String {
  return value > 9 ? "\(value)" : "0\(value)"
}

func parseToString(hours: Int, minutes: Int) -> String {
  let hoursString = twoSimbols(hours)
  let minutesString = twoSimbols(minutes)
  return "\(hoursString):\(minutesString)" 

}

class SpaceEntity: CalendarEventType, Comparable {
    var date: NSDate
    var duration: Int
    
    init(date: NSDate, duration: Int) {
        self.date = date
        self.duration = duration
    }
    
    class func findSpacesBetweenEvents(date: NSDate, var events: [EventEntity]) -> [CalendarEventType] {
        var results = [CalendarEventType]()
        events.sortInPlace()
        var i = 7 // Start time
        if events.count == 0 {
            let today = NSDate.from(year: date.getYearInt(), month: date.getMonthInt(), day: date.getDayInt(), hour: i)
            results.append(SpaceEntity(date: today, duration: 16 * 60)) // Till 23:00
        } else {
            for event in events {
                let duration = round(Double(event.duration) / 60.0 - Double(i))
                if duration > 1 {
                    let today = NSDate.from(year: date.getYearInt(), month: date.getMonthInt(), day: date.getDayInt(), hour: i)
                    results.append(SpaceEntity(date: today, duration: Int(duration) * 60)) // Till 23:00
                }
                i += Int(duration)
                results.append(event)
            }
        }
        return results
    }
}

class EventEntity: NSObject, NSCoding, Comparable, CalendarEventType {
  var name: String
  var date: NSDate
  var duration: Int
  
  var timeValue: String {
    let hours = date.hour
    let minutes = date.minute
    
    return parseToString(hours, minutes: minutes) 
  }
  
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
  
  internal func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.name, forKey: "name")
    aCoder.encodeObject(self.date, forKey: "date")
    aCoder.encodeObject(self.duration, forKey: "duration")
    aCoder.encodeObject(self.type, forKey: "type")
    aCoder.encodeObject(self.location, forKey: "location")
    aCoder.encodeObject(self.isPrivate, forKey: "isPrivate")
  }
  
  required internal init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObjectForKey("name") as! String
    self.date = aDecoder.decodeObjectForKey("date") as! NSDate
    self.duration = aDecoder.decodeObjectForKey("duration") as! Int
    self.type = aDecoder.decodeObjectForKey("type") as! Int
    self.location = aDecoder.decodeObjectForKey("location") as? Location
    self.isPrivate = aDecoder.decodeObjectForKey("isPrivate") as! Bool
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