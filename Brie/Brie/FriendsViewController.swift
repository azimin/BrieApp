//
//  SecondViewController.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var newNoteTitle: [String] = []
  var updateObserverTimer: NSTimer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 45
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidAppear(animated: Bool) {
    updateObserverTimer = NSTimer(timeInterval: 2.5, target: self, selector: Selector("update"), userInfo: nil, repeats: false)
    NSRunLoop.currentRunLoop().addTimer(updateObserverTimer!, forMode: NSRunLoopCommonModes)
  }
  
  override func viewWillDisappear(animated: Bool) {
    updateObserverTimer?.invalidate()
  }
  
  func update() {
    DataContainer.sharedInstance.getNoteTitle { (title) -> () in
      if let titleString = title where (titleString.hasPrefix("!") == false && (self.newNoteTitle.last ?? "") != titleString) {
        self.newNoteTitle.append(titleString)
        self.tableView.reloadData()
      } 
      
      self.updateObserverTimer = NSTimer(timeInterval: 2.5, target: self, selector: Selector("update"), userInfo: nil, repeats: false)
      NSRunLoop.currentRunLoop().addTimer(self.updateObserverTimer!, forMode: NSRunLoopCommonModes)
      
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBarHidden = true
  }
  
  override func az_tabBarItemContentView() -> AZTabBarItemView {
    let cell = BrieTabBarItem().az_loadFromNibIfEmbeddedInDifferentNib()
    cell.type = BrieTabBarItem.BrieTabBarItemType.Friends
    return cell
  }
}

extension FriendsViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1 + newNoteTitle.count
    } else {
      return 1
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("FriendEventCell", forIndexPath: indexPath) as! FrindEventTableViewCell
    
    if indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 && indexPath.section != tableView.numberOfSections - 1 {
      cell.separatorView.hidden = true
    } else {
      cell.separatorView.hidden = false
    }
    
    cell.userInteractionEnabled = false
    
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        cell.eventLabel.text = "Running"
      } else {
        cell.eventLabel.text = newNoteTitle[indexPath.row - 1]
      }
    } else {
      cell.eventLabel.text = "Jogging"
    }
    
    if indexPath.section == 0 && indexPath.row > 0 {
      cell.avaImageView.image = UIImage(named: "ava_image_2")
    } else {
      cell.avaImageView.image = UIImage(named: "ava_image")
    }
    
    return cell
  }
}

extension FriendsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let cell = FriendEventTimeHeaderFooterView()
    cell.timeLabel.text = section == 0 ? "07:00 - 08:00" : "13:00 - 14:00"
    return cell
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 42
  }
}