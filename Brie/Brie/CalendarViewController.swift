//
//  FirstViewController.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit
import Timepiece

class CalendarViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 45
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    self.navigationController?.navigationBarHidden = true
    
    
    // Do any additional setup after loading the view, typically from a nib.
  }
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  var flag = false
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if !flag {
      flag = true
      view.layoutIfNeeded()
//      collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 5000, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
      collectionView.selectItemAtIndexPath(NSIndexPath(forItem: 5000, inSection: 0), animated: false, scrollPosition: .CenteredHorizontally)
    }
    
  }

  override func az_tabBarItemContentView() -> AZTabBarItemView {
    let cell = BrieTabBarItem().az_loadFromNibIfEmbeddedInDifferentNib()
    cell.type = BrieTabBarItem.BrieTabBarItemType.Calendar
    return cell
  }

}

extension CalendarViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.row % 4 == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("AddCell", forIndexPath: indexPath) as! AddEventTableViewCell
      cell.showTopIfNeeded(indexPath)
      return cell
    }
    
    return tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    self.performSegueWithIdentifier("EventScreen", sender: nil)
  }
}

extension CalendarViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10000
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DayCell", forIndexPath: indexPath) as! DayCollectionViewCell
    
    let date = increaseByDays(NSDate(), days: indexPath.row - 5000)
    
    cell.dayLabel.text = "\(date.day)"
    cell.monthLabel.text = "\(date.month)"
    
    cell.updateApperance()
    
    return cell
  }
  
  func increaseByDays(date: NSDate, days: Int) -> NSDate {
    return NSCalendar.currentCalendar().dateByAddingUnit(
      .Day,
      value: days,
      toDate: date,
      options: NSCalendarOptions(rawValue: 0))!
  }
  
  func dayAfterCell(index: Int) -> NSDate {
    return NSDate().change(weekday: index)
  }
}


extension CalendarViewController: UICollectionViewDelegate {
  
}