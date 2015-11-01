//
//  PopUpTableViewController.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit
import MBProgressHUD

var providerType: PopUpProviderType = .Uber

class PopUpTableViewController: UIViewController {

  @IBOutlet weak var templateImageView: UIImageView!
  @IBOutlet weak var templateLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  var type: PopUpProviderType {
    return PopUpHelper.sharedInstance.type
  }
  
  var items: [PopUpItemType] = []
  
  var actionItems: [PopUpItemAction] {
    return items.filter() { $0 is PopUpItemAction } as? [PopUpItemAction] ?? []
  }
  
  var infoItems: [PopUpItemInfo] {
    return items.filter() { $0 is PopUpItemInfo } as? [PopUpItemInfo] ?? []
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 45
    
    templateImageView.image = type.image
    templateImageView.backgroundColor = type.color
    
    templateLabel.text = type.rawValue
      // Do any additional setup after loading the view.
    
    
    PopUpHelper.sharedInstance.item.delegate = self
    
    updateItems()
    
  }
  
  var hudView: MBProgressHUD?
  var item: PopUpProviderItemType {
    return PopUpHelper.sharedInstance.item
  }

  func updateItems() {
    items = []
    for (key, value) in item.infoDictionary {
      items.append(PopUpItemInfo(title: key, info: value))
    }
    
    for value in item.actions {
      items.append(PopUpItemAction(title: value, action: { () -> () in
        print(value)
      }))
    }
    
    if PopUpHelper.sharedInstance.item.isLoading {
      hudView?.hide(true)
      hudView = MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
    } else {
      hudView?.hide(true)
    }
    
    tableView.reloadData()
  }

}

extension PopUpTableViewController: PopUpProviderItemTypeDelegate {
  func loadingValueChanged(newValue: Bool) {
    updateItems()
  }
}

extension PopUpTableViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if item.isLoading {
      return 0
    }
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return actionItems.count
    } else {
      return infoItems.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("ActionCell", forIndexPath: indexPath) as! PopUpActionTableViewCell
      let actionItem = actionItems[indexPath.row]
      
      cell.buttonTitleLabel.text = actionItem.title
      cell.showTopIfNeeded(indexPath)
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! PopUpInfoTableViewCell
      let infoItem = infoItems[indexPath.row]
      
      cell.infoTitleLabel.text = infoItem.title
      cell.infoLabel.text = infoItem.info
      cell.showTopIfNeeded(indexPath)
      cell.userInteractionEnabled = false
      
      return cell
    }
    
  }
}

extension PopUpTableViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 16
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = UIColor.clearColor()
    return view
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let actionItem = actionItems[indexPath.row]
    actionItem.action()
  }
}
