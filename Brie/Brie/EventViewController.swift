//
//  EventViewController.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit
import Timepiece
import MapKit

class EventViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var isKeyboardOnScreen: Bool = false
  var isNew: Bool = true
  
  var selectedRowForType: Int = 0
  var entity: EventEntity!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    az_tabBarController?.setHidden(true, animated: true)
    
    var contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -60, 0.0)
    self.tableView.scrollIndicatorInsets = contentInsets
    contentInsets.bottom += 16
    self.tableView.contentInset = contentInsets
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 45
    
    self.navigationController?.delegate = self
    self.navigationController?.interactivePopGestureRecognizer?.enabled = false
    
    self.title = isNew ? "New event" : "Editing"
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: isNew ? "Add" : "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("save"))
    self.navigationItem.rightBarButtonItem?.enabled = entity.name.characters.count > 0
  }
  
  func save() {
    if isNew {
      DataContainer.sharedInstance.events.append(entity)
    }
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    registerForKeyboardNotifications()
  }
  
  deinit {
    deregisterFromKeyboardNotifications()
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func keyboardWillBeHidden(notification: NSNotification) {
    var contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
    self.tableView.scrollIndicatorInsets = contentInsets
    contentInsets.bottom += 16
    self.tableView.contentInset = contentInsets
    
    isKeyboardOnScreen = false
    //self.scrollView.scrollEnabled = false
  }
  
  func keyboardWasShown(notification: NSNotification) {
    let info: NSDictionary = notification.userInfo!
    let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().size
    var contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)

    self.tableView.scrollIndicatorInsets = contentInsets
    contentInsets.bottom += 16
    self.tableView.contentInset = contentInsets
    
    isKeyboardOnScreen = true
  }
  
  func registerForKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func deregisterFromKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
}

extension EventViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 3
    case 2:
      return 4
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("EventNameFieldCell", forIndexPath: indexPath) as! EventNameFieldTableViewCell
      cell.updateDelegate = self
      cell.entity = entity
      cell.eventNameTextField.text = entity.name
      cell.showTopIfNeeded(indexPath)
      return cell
    } else if indexPath.section == 1 {
      let cell: EventFieldTableViewCell
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("EventFieldCell", forIndexPath: indexPath) as! EventFieldTableViewCell
            cell.titleLabel.text = "Date"
            cell.selectedValueLabel.text = entity.date.novemberize()
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("EventFieldCell", forIndexPath: indexPath) as! EventFieldTableViewCell
            cell.titleLabel.text = "Time"
            cell.selectedValueLabel.text = entity.timeValue
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("EventFieldCell", forIndexPath: indexPath) as! EventFieldTableViewCell
            cell.titleLabel.text = "Duration"
            cell.selectedValueLabel.text = entity.durationValue
        }
      
      cell.showTopIfNeeded(indexPath)
      
      return cell
      
    } else if indexPath.section == 2 {
      let cell: EventFieldTableViewCell
      switch indexPath.row {
      case 0:
        cell = tableView.dequeueReusableCellWithIdentifier("EventFieldCell", forIndexPath: indexPath) as! EventFieldTableViewCell
        cell.titleLabel.text = "Type"
        cell.selectedValueLabel.text = entity.typeValue.stringValue
        cell.roundView.backgroundColor = entity.typeValue.color
        cell.roundView.hidden = false
      case 1:
        cell = tableView.dequeueReusableCellWithIdentifier("EventFieldCell", forIndexPath: indexPath) as! EventFieldTableViewCell
        cell.titleLabel.text = "Location"
        cell.selectedValueLabel.text = entity.locationValue
        cell.selectedValueLabel.textColor = entity.location == nil ? UIColor(hexString: "CBCBCB") : UIColor.blackColor()
      case 2:
        cell = tableView.dequeueReusableCellWithIdentifier("EventFieldCell", forIndexPath: indexPath) as! EventFieldTableViewCell
        cell.titleLabel.text = "Privacy"
        cell.selectedValueLabel.text = entity.isPrivate ? "Event is private" : "Event is public"
        cell.categorySwitch.hidden = false
        cell.categorySwitch.on = entity.isPrivate
      default:
        cell = tableView.dequeueReusableCellWithIdentifier("EventFieldCell", forIndexPath: indexPath) as! EventFieldTableViewCell
        cell.titleLabel.text = "Statistic"
        cell.selectedValueLabel.text = entity.name.hasPrefix("Принимать") || entity.name.hasSuffix("shower") ? "3 interactions" : "0 interactions"
        cell.alpha = entity.isPrivate ? 0.5 : 1.0
      }
      
      cell.entity = entity
      cell.showTopIfNeeded(indexPath)
      
      
      return cell
    }
    
    let cell = tableView.dequeueReusableCellWithIdentifier("EventFieldCell", forIndexPath: indexPath) as! EventFieldTableViewCell
    cell.showTopIfNeeded(indexPath)
    return cell
  }
}

extension EventViewController: UITableViewDelegate {
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
    
    if indexPath.section == 0 {
      let cell = tableView.cellForRowAtIndexPath(indexPath) as! EventNameFieldTableViewCell
      cell.eventNameTextField.becomeFirstResponder()
      return
    }
    
    if isKeyboardOnScreen {
      NSNotificationCenter.defaultCenter().postNotificationName("HideClipboard", object: nil)
    } else {
      if indexPath.section == 1 {
        if indexPath.row == 0 {
          showDatePicker()
        } else if indexPath.row == 1 {
          showTimePicker()
        } else {
          showDurationPicker()
        }
      } else {
        if indexPath.row == 0 {
          showTypePicker()
        } else if indexPath.row == 1 {
          let placePicker = LocationPickerViewController()
          let location = CLLocation(latitude: 59.9358, longitude: 30.3256)
          let initialLocation = entity.location ?? Location(name: "VK Office", location: location, placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: [:]))
          placePicker.location = initialLocation
          
          placePicker.completion = {
            (value: Location?) in 
            self.entity.location = value
            self.tableView.reloadData()
          }
          
          self.navigationController?.pushViewController(placePicker, animated: true)//(, animated: true, completion: nil)
        } else if indexPath.row == 3 {
          self.performSegueWithIdentifier("ShowStats", sender: nil)
        }
      }
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let destination = segue.destinationViewController as? StatisViewController
    destination?.event = entity
  }
  
  func showTimePicker() {
    var hours: [String] =  []
    var minutes: [String] = []
    
    for i in 0..<24 {
        hours.append(twoSimbols(i))
    }
    
    for i in 0..<4 {
        minutes.append(twoSimbols(i * 15))
    }
    
    let closest = findCloses(entity.date)
    
    ActionSheetMultipleStringPicker.showPickerWithTitle("Select Time", rows: [[""], hours, minutes, [""]], initialSelection: [0, closest.hour, closest.minute, 0], doneBlock: { (picker, result, sender) -> Void in
      
      let resultValue = result as! [Int]
      
      let hour = Int(hours[resultValue[1]])
      let minute = Int(minutes[resultValue[2]])
      
      var date = self.entity.date
      date = date.change(year: nil, month: nil, day: nil, hour: hour, minute: minute, second: nil)
      self.entity.date = date
      self.tableView.reloadData()
      
        }, cancelBlock: { (picker) -> Void in

        }, origin: self.view)
  }
  
  func findCloses(date: NSDate) -> (hour: Int, minute: Int) {
    return (date.hour, date.minute / 15)
  }
  
  func showDatePicker() {
    ActionSheetDatePicker.showPickerWithTitle("Select Date", datePickerMode: UIDatePickerMode.Date, selectedDate: entity.date, minimumDate: NSDate().beginningOfYear, maximumDate: NSDate.tomorrow().endOfYear, doneBlock: { (picker, value, sender) -> Void in
        self.entity.date = value as! NSDate
        self.tableView.reloadData()
      }, cancelBlock: { (picker) -> Void in
        
      }, origin: self.view)
  }
  
  func showDurationPicker() {
    var hours: [String] =  []
    var minutes: [String] = []
    
    for i in 0..<12 {
      hours.append(twoSimbols(i))
    }
    
    for i in 0..<4 {
      minutes.append(twoSimbols(i * 15))
    }
    
    let closest = findClosesDuration(entity.duration)
    
    ActionSheetMultipleStringPicker.showPickerWithTitle("Select Duration", rows: [[""], hours, minutes, [""]], initialSelection: [0, closest.hour, closest.minute, 0], doneBlock: { (picker, result, sender) -> Void in
        
      let resultValue = result as! [Int]
      
      let hour = Int(hours[resultValue[1]])!
      let minute = Int(minutes[resultValue[2]])!
      
      self.entity.duration = hour * 60 + minute
      self.tableView.reloadData()
      
      }, cancelBlock: { (picker) -> Void in
          
      }, origin: self.view)
  }
  
  func findClosesDuration(value: Int) -> (hour: Int, minute: Int) {
    return (value / 60, value % 60 / 15)
  }
  
  func showTypePicker() {
    ActionSheetCustomPicker.showPickerWithTitle("Select Type", delegate: self, showCancelButton: true, origin: self.view)
  }
}

extension EventViewController: UINavigationControllerDelegate {
  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    if viewController is CalendarViewController {
      viewController.navigationController?.setNavigationBarHidden(true, animated: true)
      viewController.az_tabBarController?.setHidden(false, animated: true)
    } else {
      viewController.navigationController?.setNavigationBarHidden(false, animated: true)
    }
  }
  
}

extension EventViewController: ActionSheetCustomPickerDelegate {
  func actionSheetPicker(actionSheetPicker: AbstractActionSheetPicker!, configurePickerView pickerView: UIPickerView!) {
    pickerView.delegate = self
    pickerView.selectRow(entity.type, inComponent: 0, animated: false)
  }
  
  func actionSheetPickerDidSucceed(actionSheetPicker: AbstractActionSheetPicker!, origin: AnyObject!) {
    entity.type = selectedRowForType
    tableView.reloadData()
  }
  
  func actionSheetPickerDidCancel(actionSheetPicker: AbstractActionSheetPicker!, origin: AnyObject!) {
    
  }
}

extension EventViewController: UIPickerViewDataSource {
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return CalendarType.values.count
  }
}

extension EventViewController: UIPickerViewDelegate {
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedRowForType = row
  }
  
  func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    let value = CalendarType.values[row]
    return NSAttributedString(string: value.stringValue, attributes: [NSForegroundColorAttributeName: value.color])
  }
}

extension EventViewController: EventNameFieldTableViewCellDelegate {
  func needToCheckSaveButton() {
    self.navigationItem.rightBarButtonItem?.enabled = entity.name.characters.count > 0
  }
}

// ----
