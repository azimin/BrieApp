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
  case KudaGo
  case Uber
  case Iiko
  
  var image: UIImage {
    switch self {
    case .KudaGo:
      return UIImage(named: "logo_KudaGO")!
    case .Iiko:
      return UIImage(named: "logo_Iiko")!
    case .Uber:
      return UIImage(named: "logo_Uber")!
    }
  }
  
  var color: UIColor {
    switch self {
    case .KudaGo:
      return UIColor(hexString: "D25143")
    case .Iiko:
      return UIColor(hexString: "91C696")
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