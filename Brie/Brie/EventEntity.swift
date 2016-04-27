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
    
    func getHoursInt() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Month, .Year], fromDate: self)
        return components.hour
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
    
    var timeValue: String {
        let startHour = date.hour
        let endHour = date.increaseByHours(duration / 60).hour
      return "\(parseToString(startHour, minutes: 0)) — \(parseToString(endHour, minutes: 0))"
    }
    
    init(date: NSDate, duration: Int) {
        self.date = date
        self.duration = duration
    }
  
  class func findSpacesBetweenEvents(date: NSDate, unsortedEvents: [EventEntity]) -> [CalendarEventType] {
    var results = [CalendarEventType]()
    let events = unsortedEvents.sort()
    let today = date.createDate(7)
    
    if (events.count == 0) {
      results.append(SpaceEntity(date: today, duration: 16 * 60)) // Till 23:00
      return results
    }
    
    if (events.count > 0 && events.last!.date.hour < 7) {
      for element in events {
        results.append(element)
      }
      results.append(SpaceEntity(date: today, duration: 16 * 60)) // Till 23:00
      return results
    }
    
    if events.count == 1 && events.first!.date.hour > 7 {
      let event = events.first!
      results.append(SpaceEntity(date: today, duration: (event.date.hour - 7) * 60)) // Till 23:00
      results.append(event)
      results.append(SpaceEntity(date: event.date.increaseByHours(1), duration: (23 - event.date.hour) * 60)) // Till 23:00
      return results
    }
    
    var preveousValue: EventEntity = events.first!
    
    if preveousValue.date.hour > 7 {
      results.append(SpaceEntity(date: today, duration: (preveousValue.date.hour - 7) * 60)) // Till 23:00
    }
    
    results.append(preveousValue)
    
    for event in events[1..<events.count] {
      if event.date.hour <= 7 {
        results.append(event)
        preveousValue = event
        continue
      }
      
      if event.date.hour - preveousValue.date.hour > 1 {
        results.append(SpaceEntity(date: preveousValue.date.increaseByHours(1), duration: (event.date.hour - preveousValue.date.hour - 1) * 60)) // Till 23:00
      }
      
      results.append(event)
      preveousValue = event
    }
    
    if preveousValue.date.hour < 22 {
      results.append(SpaceEntity(date: preveousValue.date.increaseByHours(1), duration: (22 - preveousValue.date.hour) * 60)) // Till 23:00
    }
    
    return results
  }
    
    class func findSpacesBetweenEvents2(date: NSDate, unsortedEvents: [EventEntity]) -> [CalendarEventType] {
        var results = [CalendarEventType]()
        let events = unsortedEvents.sort()
        let today = date.createDate(7)
        if events.count == 0 {
            results.append(SpaceEntity(date: today, duration: 16 * 60)) // Till 23:00
        } else {
            for i in 0..<events.count {
                var duration = 0
                if i == 0 {
                    duration = events[i].date.hoursFrom(today) * 60
                    if duration > 59 {
                        results.append(SpaceEntity(date: today, duration: Int(duration) * 60)) // Till 23:00
                    }
                    results.append(events[i])
                } else {
                    duration = events[i].date.hoursFrom(events[i - 1].date) * 60
                    if duration > 59 {
                        let count = Int(round(Double(events[i - 1].duration) / 60.0))
                        let time = date.createDate(events[i - 1].date.getHoursInt()).increaseByHours(count)
                        results.append(SpaceEntity(date: time, duration: Int(duration) * 60)) // Till 23:00
                    }
                    results.append(events[i])
                }
            }
            let evening = date.createDate(23)
            let count = Int(round(Double(events[events.count - 1].duration) / 60.0))
            let finishedLast = date.createDate(events[events.count - 1].date.getHoursInt()).increaseByHours(count)
            if evening.hoursFrom(finishedLast) >= 1 {
                results.append(SpaceEntity(date: finishedLast, duration: evening.hoursFrom(finishedLast) * 60))
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
    return location == nil ? "Location is not selected" : location?.name ?? location?.address ?? "Location"
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
    let type = TextAnalyzer.classifier.classify(self.name)
    
    if type == "uber" {
      return .Uber
    } else if type == "food" {
      return .Foursquare
    } else if type == "fun" {
      return .Eventbrite
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