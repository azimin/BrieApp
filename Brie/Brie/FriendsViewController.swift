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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
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
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("FriendEventCell", forIndexPath: indexPath) as! FrindEventTableViewCell
    
    if indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 && indexPath.section != tableView.numberOfSections - 1 {
      cell.separatorView.hidden = true
    } else {
      cell.separatorView.hidden = false
    }
    
    return cell
  }
}

extension FriendsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return FriendEventTimeHeaderFooterView()
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 42
  }
}