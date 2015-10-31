//
//  DayCollectionViewCell.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var monthLabel: UILabel!
  
  @IBOutlet weak var leftSeparator: UIView!
  @IBOutlet weak var rightSeparator: UIView!
  
  override var selected: Bool {
    didSet {
      updateApperance()
    }
  }
  
  func updateApperance() {
    leftSeparator.hidden = !selected
    rightSeparator.hidden = !selected
    contentView.backgroundColor = selected ? UIColor(hexString: "F2F2F2") : UIColor.clearColor()
  }
}
