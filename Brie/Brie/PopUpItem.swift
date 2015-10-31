//
//  PopUpItem.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Foundation

protocol PopUpItemType { }

class PopUpItemAction: PopUpItemType {
  var title: String
  var object: AnyObject?
  var action: () -> ()
  
  init(title: String, action: () -> (), object: AnyObject? = nil) {
    self.title = title
    self.action = action
    self.object = object
  }
}

class PopUpItemInfo: PopUpItemType {
  var title: String
  var object: AnyObject?
  var info: String
  
  init(title: String, info: String, object: AnyObject? = nil) {
    self.title = title
    self.info = info
    self.object = object
  }
}