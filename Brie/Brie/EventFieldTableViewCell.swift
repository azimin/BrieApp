//
//  EventFieldTableViewCell.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class EventFieldTableViewCell: BaseTableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var selectedValueLabel: UILabel!
  
  @IBOutlet weak var categorySwitch: UISwitch!
  @IBOutlet weak var roundView: UCRoundedView!
  
  var entity: EventEntity!
  var updateDelegate: EventNameFieldTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setHighlighted(highlighted: Bool, animated: Bool) {
    if categorySwitch.hidden {
      super.setHighlighted(highlighted, animated: animated)
    }
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    
    if categorySwitch.hidden {
      super.setSelected(selected, animated: animated)
    }
    
    // Configure the view for the selected state
  }
  
  @IBAction func switcherAction(sender: UISwitch) {
    entity.isPrivate = sender.on
    self.selectedValueLabel.text = sender.on ? "Event is private" : "Event is public"
  }
  
  override func prepareForReuse() {
    self.categorySwitch.hidden = true
    self.roundView.hidden = true
    self.selectedValueLabel.textColor = UIColor.blackColor()
  }
}
