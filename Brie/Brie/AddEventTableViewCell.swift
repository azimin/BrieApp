//
//  AddEventTableViewCell.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class AddEventTableViewCell: BaseTableViewCell {
  
  var entity: SpaceEntity!
  
  @IBOutlet weak var actionView: UIView!
  @IBOutlet weak var actionWidthConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var addEventLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
}
