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
import MapKit

class CalendarViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var selectedIndexPath = NSIndexPath(forItem: 5000, inSection: 0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    eventsItself = DataContainer.sharedInstance.eventsOnTheDay(NSDate())
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 45
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    self.navigationController?.navigationBarHidden = true
    
    PopUpHelper.sharedInstance.type = .Uber
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData", name: "UpdateEvents", object: nil)
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  var flag = false
  var date: NSDate {
    return self.increaseByDays(NSDate(), days: selectedIndexPath.item - 5000) 
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    view.layoutIfNeeded()
    collectionView.selectItemAtIndexPath(selectedIndexPath, animated: false, scrollPosition: .CenteredHorizontally)
    updateData()
  }
  
  func updateData() {
    print(date.day)
    eventsItself = DataContainer.sharedInstance.eventsOnTheDay(date)
    self.tableView.reloadData()
    DataContainer.sharedInstance.save()
  }
  
  var eventsItself = DataContainer.sharedInstance.eventsOnTheDay(NSDate()) {
    didSet {
      events = SpaceEntity.findSpacesBetweenEvents(date, events: eventsItself)
    }
  }
  var events: [CalendarEventType] = []

  var interestinEventIndexPath: NSIndexPath?
  
  override func az_tabBarItemContentView() -> AZTabBarItemView {
    let cell = BrieTabBarItem().az_loadFromNibIfEmbeddedInDifferentNib()
    cell.type = BrieTabBarItem.BrieTabBarItemType.Calendar
    return cell
  }

}

extension CalendarViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    interestinEventIndexPath = nil
    return events.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    if indexPath.row % 4 == 0 {
//      let cell = tableView.dequeueReusableCellWithIdentifier("AddCell", forIndexPath: indexPath) as! AddEventTableViewCell
//      cell.showTopIfNeeded(indexPath)
//      return cell
//    }
    
    let event = events[indexPath.row] 
    
    if let eventItself = event as? EventEntity {
      return eventCell(eventItself, tableView: tableView, cellForRowAtIndexPath: indexPath)
    } else {
      let spaceEntity = event as! SpaceEntity
      let cell = tableView.dequeueReusableCellWithIdentifier("AddCell", forIndexPath: indexPath) as! AddEventTableViewCell
      cell.showTopIfNeeded(indexPath)
      cell.timeLabel.text = spaceEntity.timeValue ?? "--:--"
      
      if (interestinEventIndexPath == nil && spaceEntity.date.increaseByHours(spaceEntity.duration / 60).hour > 17) || interestinEventIndexPath == indexPath {
        cell.leftButtons = [MGSwipeButton(title: PopUpProviderType.KudaGo.rawValue, backgroundColor: PopUpProviderType.KudaGo.color, insets: UIEdgeInsetsMake(0, 16, 0, 16))]
        interestinEventIndexPath = indexPath
        cell.actionWidthConstraint.constant = 28
        cell.actionView.backgroundColor = PopUpProviderType.KudaGo.color
      } else {
        cell.leftButtons = nil
        cell.actionWidthConstraint.constant = 0
      }
      
      cell.delegate = self
      cell.entity = spaceEntity
      
      return cell
    }
  }
  
  func eventCell(event: EventEntity, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
    
    cell.mainLabel.text = event.timeValue
    cell.secondLabel.text = event.name
    cell.type = event.typeValue
    
    cell.showTopIfNeeded(indexPath)
    cell.delegate = self
    
    if let provider = event.provider {
      cell.leftButtons = [MGSwipeButton(title: provider.rawValue, backgroundColor: provider.color, insets: UIEdgeInsetsMake(0, 16, 0, 16))]
      cell.actionWidthConstraint.constant = 28
      cell.actionView.backgroundColor = provider.color
    } else {
      cell.leftButtons = nil
      cell.actionWidthConstraint.constant = 0
    }
    
    cell.entity = event
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let event = events[indexPath.row] 
    
    if let eventItself = event as? EventEntity {
      self.performSegueWithIdentifier("EventScreen", sender: eventItself)
    } else if let space = event as? SpaceEntity  {
      self.performSegueWithIdentifier("EventScreen", sender: space)
    }
    
    
  }
}

extension CalendarViewController: MGSwipeTableCellDelegate {
  func swipeTableCellWillBeginSwiping(cell: MGSwipeTableCell!) {
    if let cell = cell as? EventTableViewCell {
      cell.actionWidthConstraint.constant = 0
    } else if let cell = cell as? AddEventTableViewCell {
      cell.actionWidthConstraint.constant = 0
    }
    
    UIView.animateWithDuration(0.2) { () -> Void in
      cell.layoutIfNeeded()
    }
  }
  
  func swipeTableCellWillEndSwiping(cell: MGSwipeTableCell!) {
    if let cell = cell as? EventTableViewCell {
      cell.actionWidthConstraint.constant = 28
    } else if let cell = cell as? AddEventTableViewCell {
      cell.actionWidthConstraint.constant = 28
    }

    UIView.animateWithDuration(0.2) { () -> Void in
      cell.layoutIfNeeded()
    }
  }
  
  func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {

    if let entity = (cell as? EventTableViewCell)?.entity {
      
      if entity.provider == .Uber {
        if let location = entity.location {
          UberAuth.priceForRide(myCoord, to: CLLocation(latitude: location.coordinate.latitude ?? 0.0, longitude: location.coordinate.longitude ?? 0.0), isEndLocation: true)
        } else {
          UberAuth.priceForRide(myCoord, to: myCoord, isEndLocation: false)
        }
      } else {
        PopUpHelper.sharedInstance.type = .Iiko
        PopUpHelper.sharedInstance.item = PopUpProviderItem()
      }
      
      helperValue = entity
      
      TAWindowShower.sharedInstance.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("PopUp"), animationDataSource: nil)
      return true
    } else if let entity = (cell as? AddEventTableViewCell)?.entity {
      PopUpHelper.sharedInstance.type = .KudaGo
      
      let startUnix = nsdateToUnix(entity.date)
      let endUnix = nsdateToUnix(entity.date.increaseByHours(entity.duration / 60))
      
      let kudaGo = PopUpProviderItem()
      PopUpHelper.sharedInstance.item = kudaGo
      
      helperValue = entity
      
      KudaGoAuth.eventsInRange(startUnix, end: endUnix) { (json) -> Void in
        print(json)
        
        
//        var infos: [String: String] = [:]
//        
//        for element in json["results"].arrayValue {
//          infos[element["title"].stringValue] = "4.4"
//        }
//        
//        kudaGo.infoDictionary = infos
        
        var action: [String] = []
        
        for element in json["results"].arrayValue {
          action.append(element["title"].stringValue)
        }
        
        kudaGo.actions = action
        kudaGo.isLoading = false
      }
      
      TAWindowShower.sharedInstance.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("PopUp"), animationDataSource: nil)
      return true
    }
    
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
    selectedIndexPath = indexPath
    updateData()
  }
}

extension CalendarViewController {
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    let eventViewController = segue.destinationViewController as? EventViewController
    
    if let space = sender as? SpaceEntity {
      eventViewController!.entity = EventEntity(name: "", date: space.date, duration: 60, type: 0, location: nil, isPrivate: true)
    } else if let entity = sender as? EventEntity {
      eventViewController!.entity = entity
      eventViewController!.isNew = false
    }
    
    
  }
}
