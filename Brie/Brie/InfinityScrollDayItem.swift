//
//  InfinityScrollDayItem.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class InfinityScrollDayItem: UIView {
  let dateLabel = UILabel()
  let monthLabel = UILabel()
  
  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
    
    dateLabel.frame = CGRect(x: 16, y: 17, width: 42, height: 21)
    dateLabel.text = "31"
    dateLabel.textAlignment = .Center
    self.addSubview(dateLabel)
    
    monthLabel.frame = CGRect(x: 16, y: 17, width: 42, height: 21)
    monthLabel.text = "Nov"
    monthLabel.textAlignment = .Center
    self.addSubview(monthLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
