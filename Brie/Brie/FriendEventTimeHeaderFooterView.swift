//
//  FriendEventTimeHeaderFooterView.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class FriendEventTimeHeaderFooterView: UITableViewHeaderFooterView {

  var timeLabel: UILabel = UILabel()
  
  var topSeparatorView = UIView()
  let separatorView = UIView()
  
  init() {
    super.init(reuseIdentifier: nil)
    timeLabel.textAlignment = .Center
    timeLabel.text = "11:00 - 12:00"
    timeLabel.textColor = UIColor(hexString: "666666")
    
    self.contentView.addSubview(timeLabel)
    self.contentView.backgroundColor = UIColor.clearColor()
    
    separatorView.backgroundColor = UIColor(hexString: "C9C9C9")
    self.addSubview(separatorView)
    
    topSeparatorView.backgroundColor = UIColor(hexString: "C9C9C9")
    self.addSubview(topSeparatorView)
    
    updateSeparatorView()
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    timeLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
    updateSeparatorView()
  }

  func updateSeparatorView() {
    separatorView.frame = CGRect(x: 0, y: self.bounds.size.height - 1, width: self.bounds.size.width, height: 1)
    topSeparatorView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1)
  }
}
