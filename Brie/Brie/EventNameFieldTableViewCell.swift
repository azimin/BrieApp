//
//  EventNameFieldTableViewCell.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class EventNameFieldTableViewCell: BaseTableViewCell {
  
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var eventNameTextField: UITextField! {
    didSet {
      eventNameTextField.delegate = self
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("close"), name: "HideClipboard", object: nil)
    // Initialization code
  }
  
  func close() {
    eventNameTextField.resignFirstResponder()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

extension EventNameFieldTableViewCell: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}