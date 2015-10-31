//
//  EventTableViewCell.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class EventTableViewCell: BaseTableViewCell {

  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var secondLabel: UILabel!
  @IBOutlet weak var actionView: UIView!
  
  @IBOutlet weak var circleView: UCRoundedView!
  
  @IBOutlet weak var actionWidthConstraint: NSLayoutConstraint!
  
  var type: CalendarType = .Work {
    didSet {
      circleView.backgroundColor = type.color
    }
  }
  
}
