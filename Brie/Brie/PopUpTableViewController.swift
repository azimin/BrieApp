//
//  PopUpTableViewController.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON

var providerType: PopUpProviderType = .Uber

class PopUpTableViewController: UIViewController {

  @IBOutlet weak var templateImageView: UIImageView!
  @IBOutlet weak var templateLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  var type: PopUpProviderType {
    return PopUpHelper.sharedInstance.type
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 45
    
    templateImageView.image = type.image
    templateImageView.backgroundColor = type.color
    
    templateLabel.text = type.rawValue
      // Do any additional setup after loading the view.
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateItems", name: "UpdatePopUp", object: nil)
    
    updateItems()
    
  }
  
  deinit {
    print("Swag")
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  var hudView: MBProgressHUD?
  var item: PopUpProviderItem {
    return PopUpHelper.sharedInstance.item
  }

  func updateItems() {
    values = []
    
    for (key, dicValue) in item.infoDictionary {
      values.append((key, dicValue))
    }
    
    print(item.isLoading)
    
    if item.isLoading {
      hudView?.hide(true)
      hudView = MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
    } else {
      hudView?.hide(true)
    }
    
    tableView.reloadData()
  }


  var values: [(key: String, value: String)] = []
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
      return item.actions.count
    } else {
      return item.infoDictionary.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("ActionCell", forIndexPath: indexPath) as! PopUpActionTableViewCell
      
      cell.buttonTitleLabel.text = item.actions[indexPath.row]
      cell.showTopIfNeeded(indexPath)
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! PopUpInfoTableViewCell
      //let infoItem = infoItems[indexPath.row]

      cell.infoTitleLabel.text = values[indexPath.row].key
      cell.infoLabel.text = values[indexPath.row].value
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
    
    if type == .KudaGo {
      let entity = EventEntity(name: item.actions[indexPath.row], date: (helperValue as! SpaceEntity).date, duration: 60, type: 1, location: nil, isPrivate: true)
      DataContainer.sharedInstance.events.append(entity)
      NSNotificationCenter.defaultCenter().postNotificationName("UpdateEvents", object: nil)
    } else {
      if let entity = (helperValue as? EventEntity) {
        let location = myCoord
        UberAuth.openApp(Float(entity.location?.location.coordinate.latitude ?? location.coordinate.latitude), longitude: Float(entity.location?.location.coordinate.longitude ?? location.coordinate.longitude), dropOffName: entity.locationValue)
      }
      
    }
    
    TAWindowShower.sharedInstance.closeTopWindow()
  }
}
