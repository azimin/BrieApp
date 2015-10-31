//
//  CalendarType.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

enum CalendarType: Int {
  case Work = 0
  case Leisure
  case Food
  case Sport
  case Travel
  
  var color: UIColor {
    switch self {
    case .Work:
      return UIColor(hexString: "CE737E")
    case .Leisure:
      return UIColor(hexString: "73A0CE")
    case .Food:
      return UIColor(hexString: "E8A451")
    case .Sport:
      return UIColor(hexString: "91C696")
    case .Travel:
      return UIColor(hexString: "8F72E6")
    }
  }
  
  var stringValue: String {
    switch self {
    case .Work:
      return "Work"
    case .Leisure:
      return "Leisure"
    case .Food:
      return "Food"
    case .Sport:
      return "Sport"
    case .Travel:
      return "Travel"
    }
  }
  
  static var values: [CalendarType] = [.Work, .Leisure, .Food, .Sport, .Travel]
}