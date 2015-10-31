//
//  SettingsViewController.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  override func az_tabBarItemContentView() -> AZTabBarItemView {
    let cell = BrieTabBarItem().az_loadFromNibIfEmbeddedInDifferentNib()
    cell.type = BrieTabBarItem.BrieTabBarItemType.Setting
    return cell
  }

}

extension SettingsViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 3
    case 1:
      return 2
    case 2:
      return 2
    case 3:
      return 1
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell", forIndexPath: indexPath) as! BaseTableViewCell
    let label = cell.viewWithTag(10) as! UILabel
    label.text = title(indexPath)
    
    if indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 && indexPath.section != tableView.numberOfSections - 1 {
      cell.separatorView.hidden = true
    } else {
      cell.separatorView.hidden = false
    }
    
    return cell
  }
  
  func title(indexPath: NSIndexPath) -> String {
    if indexPath.section == 0 {
      switch indexPath.row {
      case 0:
        return "Vk"
      case 1:
        return "Twitter"
      default:
        return "Uber"
      }
    } else if indexPath.section == 1 {
      switch indexPath.row {
      case 0:
        return "iCal"
      default:
        return "Google"
      }
    } else if indexPath.section == 2 {
      switch indexPath.row {
      case 0:
        return "Common events"
      default:
        return "Daytime"
      }
    }
    
    return ""
  }
}

extension SettingsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = FriendEventTimeHeaderFooterView()
    
    switch section {
    case 0:
      view.timeLabel.text = "Accounts"
    case 1:
      view.timeLabel.text = "Import/export"
    default:
      view.timeLabel.text = "Advanced"
    }
    
    
    
    return view
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 42
  }
}