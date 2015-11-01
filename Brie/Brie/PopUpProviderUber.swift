//
//  PopUpProviderUber.swift
//  Brie
//
//  Created by Alex Zimin on 01/11/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Foundation


class PopUpProviderItem {
  var isLoading: Bool = true {
    didSet {
      dispatch_async(dispatch_get_main_queue(),{
        if !self.isLoading {
          NSNotificationCenter.defaultCenter().postNotificationName("UpdatePopUp", object: nil)
        }
      
      })
    }
  }
  
  var infoDictionary: [String: String] = [:]
  var actions: [String] = []
}

extension Dictionary {
  mutating func setObjectIfNeeded(value: Value?, forKey key: Key) {
    if let value = value {
      self[key] = value
    }
  }
}