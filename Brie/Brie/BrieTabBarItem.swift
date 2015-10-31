//
//  BrieTabBarItem.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class BrieTabBarItem: AZTabBarItemView {
  enum BrieTabBarItemType: String {
    case Calendar = "img_calendar_icon"
    case Friends = "img_friends_icon"
    case Setting = "img_settings_icon"
    
    var image: UIImage {
      return UIImage(named: self.rawValue)!
    }
  }
  
  override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
    return self.az_loadFromNibIfEmbeddedInDifferentNib()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = UIColor(hexString: "515CBD")
  }
  
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var selectionImageView: UIImageView!
  
  var type: BrieTabBarItemType = .Calendar {
    didSet {
      iconImageView.image = type.image
    }
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    self.selectionImageView.alpha = selected ? 1.0 : 0.0
    self.iconImageView.alpha = selected ? 1.0 : 0.5
  }
}