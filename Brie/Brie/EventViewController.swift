//
//  EventViewController.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit
import Timepiece

class EventViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var isKeyboardOnScreen: Bool = false
  
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
    // Do any additional setup after loading the view.
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
      return 3
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("EventNameFieldCell", forIndexPath: indexPath) as! EventNameFieldTableViewCell
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
      }
    }
  }
  
  func showTimePicker() {
    ActionSheetDatePicker.showPickerWithTitle("Select Time", datePickerMode: UIDatePickerMode.Time, selectedDate: NSDate(), minimumDate: NSDate().beginningOfYear, maximumDate: NSDate().endOfYear, doneBlock: { (picker, value, sender) -> Void in
      
      }, cancelBlock: { (picker) -> Void in
        
      }, origin: self.view)
  }
  
  func showDatePicker() {
    ActionSheetDatePicker.showPickerWithTitle("Select Date", datePickerMode: UIDatePickerMode.Date, selectedDate: NSDate(), minimumDate: NSDate.yesterday(), maximumDate: NSDate.tomorrow(), doneBlock: { (picker, value, sender) -> Void in
      
      }, cancelBlock: { (picker) -> Void in
        
      }, origin: self.view)
  }
  
  func showDurationPicker() {
    var hours: [String] =  []
    var minutes: [String] = []
    
    for i in 0..<12 {
      hours.append("\(i+1)")
    }
    
    for i in 0..<4 {
      minutes.append("\(i * 15)")
    }
    
    ActionSheetMultipleStringPicker.showPickerWithTitle("Select Duration", rows: [[""], hours, minutes, [""]], initialSelection: [0, 1, 0, 0], doneBlock: { (picker, result, sender) -> Void in
        
      }, cancelBlock: { (picker) -> Void in
          
      }, origin: self.view)
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