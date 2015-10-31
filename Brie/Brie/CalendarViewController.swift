//
//  FirstViewController.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit
import Timepiece
import MGSwipeTableCell

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
  
  var events = DataContainer.sharedInstance.eventsOnTheDay(NSDate())

  override func az_tabBarItemContentView() -> AZTabBarItemView {
    let cell = BrieTabBarItem().az_loadFromNibIfEmbeddedInDifferentNib()
    cell.type = BrieTabBarItem.BrieTabBarItemType.Calendar
    return cell
  }

}

extension CalendarViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.row % 4 == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("AddCell", forIndexPath: indexPath) as! AddEventTableViewCell
      cell.showTopIfNeeded(indexPath)
      return cell
    }
    
    let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
    cell.leftButtons = [MGSwipeButton(title: "Test", backgroundColor: UIColor(hexString: "91C696"), insets: UIEdgeInsetsMake(0, 16, 0, 16))]
    
    cell.delegate = self
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    self.performSegueWithIdentifier("EventScreen", sender: nil)
  }
}

extension CalendarViewController: MGSwipeTableCellDelegate {
  func swipeTableCellWillBeginSwiping(cell: MGSwipeTableCell!) {
    guard let cell = cell as? EventTableViewCell else {
      return
    }
    cell.actionWidthConstraint.constant = 0
    UIView.animateWithDuration(0.2) { () -> Void in
      cell.layoutIfNeeded()
    }
  }
  
  func swipeTableCellWillEndSwiping(cell: MGSwipeTableCell!) {
    guard let cell = cell as? EventTableViewCell else {
      return
    }
    cell.actionWidthConstraint.constant = 28
    UIView.animateWithDuration(0.2) { () -> Void in
      cell.layoutIfNeeded()
    }
  }
  
  func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
    TAWindowShower.sharedInstance.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("PopUp"), animationDataSource: nil)
     return true
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
    cell.monthLabel.text = "\(date.getMonth().makeShortAndBeautiful())"
    
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
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
  }
}

extension CalendarViewController {
  
}


