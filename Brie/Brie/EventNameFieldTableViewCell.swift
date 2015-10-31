//
//  EventNameFieldTableViewCell.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

protocol EventNameFieldTableViewCellDelegate {
  func needToCheckSaveButton()
}

class EventNameFieldTableViewCell: BaseTableViewCell {
  
  var entity: EventEntity!
  var updateDelegate: EventNameFieldTableViewCellDelegate?
  
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
  
  @IBAction func textFieldTextChanged(sender: UITextField) {
    entity.name = sender.text ?? ""
    updateDelegate?.needToCheckSaveButton()
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