//
//  BrieTabBarItem.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class BrieTabBarItem: AZTabBarItemView {
  override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
    return self.az_loadFromNibIfEmbeddedInDifferentNib()
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  
  override func setSelected(selected: Bool, animated: Bool) {
    if selected {
      self.backgroundColor = UIColor.redColor()
    } else {
      self.backgroundColor = UIColor.blueColor()
    }
    
    titleLabel.alpha = selected ? 0.0 : 1.0
    UIView.animateWithDuration(animated ? 0.35 : 0.0) { () -> Void in
      self.titleLabel.alpha = selected ? 1.0 : 0.0
    }
    
    titleLabel.text = "\(index)"
  }
}