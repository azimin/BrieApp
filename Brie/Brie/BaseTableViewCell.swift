//
//  BaseTableViewCell.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

let defaultRules: (indexPath: NSIndexPath) -> (Bool) = {
  indexPath in
  return indexPath.row == 0
}

class BaseTableViewCell: UITableViewCell {
  
  var topSeparatorView = UIView()
  let separatorView = UIView()
  
  var topRules: (indexPath: NSIndexPath) -> (Bool) = defaultRules
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    separatorView.backgroundColor = UIColor(hexString: "C9C9C9")
    self.addSubview(separatorView)
    
    topSeparatorView.backgroundColor = UIColor(hexString: "C9C9C9")
    topSeparatorView.hidden = true
    self.addSubview(topSeparatorView)
    
    backgroundColorCache = self.backgroundColor
    
    updateSeparatorView()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateSeparatorView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.topSeparatorView.hidden = true
  }
  
  func showTopIfNeeded(indexPath: NSIndexPath) {
    let topIsNeeded = topRules(indexPath: indexPath)
    topSeparatorView.hidden = !topIsNeeded
  }
  
  func updateSeparatorView() {
    separatorView.frame = CGRect(x: 0, y: self.bounds.size.height - 1, width: self.bounds.size.width, height: 1)
    topSeparatorView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1)
  }
  
  var backgroundColorCache: UIColor!
  
  override func setHighlighted(highlighted: Bool, animated: Bool) {
    if highlighted {
      self.backgroundColor = UIColor(hexString: "E6E6E6")
    } else {
      self.backgroundColor = backgroundColorCache
    }
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    if selected {
      self.backgroundColor = UIColor(hexString: "E6E6E6")
    } else {
      self.backgroundColor = backgroundColorCache
    }
  }
}
