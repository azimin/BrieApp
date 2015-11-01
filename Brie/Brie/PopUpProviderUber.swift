//
//  PopUpProviderUber.swift
//  Brie
//
//  Created by Alex Zimin on 01/11/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Foundation

protocol PopUpProviderItemTypeDelegate {
  func loadingValueChanged(newValue: Bool)
}

protocol PopUpProviderItemType {
  var isLoading: Bool { get set }
  var infoDictionary: [String: String] { get }
  var actions: [String] { get set }
  var delegate: PopUpProviderItemTypeDelegate? { get set }
}

class PopUpProviderUber: PopUpProviderItemType {
  var isLoading = true {
    didSet {
      delegate?.loadingValueChanged(isLoading)
    }
  }
  var waitingTime: Int?
  var price: Int?
  var distance: CGFloat?
  
  var delegate: PopUpProviderItemTypeDelegate? 
  
  var actions: [String] = []
  var infoDictionary: [String: String] {
    var keys: [String: String] = [:]
    if let waitingTime = waitingTime {
      keys["Waiting time"] = "\(waitingTime / 60) min"
    }
    
    if let price = price {
      keys["Price"] = "\(price) $"
    }
    
    if let distance = distance {
      keys["Distance time"] = "\(distance / 1000) km"
    }
    
    return keys
  }
}