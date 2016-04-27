//
//  PopUpHelper.swift
//  Brie
//
//  Created by Alex Zimin on 01/11/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Foundation

var helperValue: AnyObject?

enum PopUpProviderType: String {
  case Eventbrite
  case Uber
  case Foursquare
  
  var image: UIImage {
    switch self {
    case .Eventbrite:
      return UIImage(named: "logo_KudaGO")!
    case .Foursquare:
      return UIImage(named: "logo_Iiko")!
    case .Uber:
      return UIImage(named: "logo_Uber")!
    }
  }
  
  var color: UIColor {
    switch self {
    case .Eventbrite:
      return UIColor(hexString: "FF8000")
    case .Foursquare:
      return UIColor(hexString: "F94877")
    case .Uber:
      return UIColor.blackColor()
    }
  }
}

class PopUpHelper {
  static let sharedInstance = PopUpHelper()
  
  var type: PopUpProviderType = .Uber
  var item: PopUpProviderItem!
}