//
//  ComplicationController.swift
//  VadimDrobininWatch Extension
//
//  Created by Vadim Drobinin on 28/4/16.
//  Copyright © 2016 700 km. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
  
  let lines = ["🗓 19:45 Theater", "🗓 21:10 Club", "🗓 03:40 Meeting"]
  
  func createTimeLineEntry(headerText: String, date: NSDate) -> CLKComplicationTimelineEntry {
    let template = CLKComplicationTemplateModularLargeTallBody()
    template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
    template.bodyTextProvider = CLKSimpleTextProvider(text: "→ GO")
    let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    return(entry)
  }
  
  // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
      let currentDate = NSDate()
      handler(currentDate)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
      let currentDate = NSDate()
      let endDate = currentDate.dateByAddingTimeInterval(NSTimeInterval(24 * 60 * 60))
      handler(endDate)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
      if complication.family == .ModularLarge {
        let entry = createTimeLineEntry(lines[0], date: NSDate())
        handler(entry)
      } else {
        handler(nil)
      }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
      var timeLineEntryArray = [CLKComplicationTimelineEntry]()
      var nextDate = NSDate(timeIntervalSinceNow: 1 * 60 * 60)
      for index in 1...2 {
        let entry = createTimeLineEntry(lines[index], date: nextDate)
        timeLineEntryArray.append(entry)
        nextDate = nextDate.dateByAddingTimeInterval(1 * 60 * 60)
      }
      handler(timeLineEntryArray)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
      let template = CLKComplicationTemplateModularLargeTallBody()
      template.headerTextProvider = CLKSimpleTextProvider(text: "🗓 19:45 Theater with Ann")
      template.bodyTextProvider = CLKSimpleTextProvider(text: "→ activate hints")
      handler(template)
    }
    
}
