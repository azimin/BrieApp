//
//  PopUpTableViewController.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

enum PopUpProviderType: String {
  case KudaGo
  case Uber
  case Iiko
  
  var image: UIImage {
    switch self {
    case .KudaGo:
      return UIImage(named: "logo_KudaGO")!
    case .Iiko:
      return UIImage(named: "logo_Iiko")!
    case .Uber:
      return UIImage(named: "logo_Uber")!
    }
  }
  
  var color: UIColor {
    switch self {
    case .KudaGo:
      return UIColor(hexString: "D25143")
    case .Iiko:
      return UIColor(hexString: "91C696")
    case .Uber:
      return UIColor.blackColor()
    }
  }
}

class PopUpTableViewController: UIViewController {

  @IBOutlet weak var templateImageView: UIImageView!
  @IBOutlet weak var templateLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  var type: PopUpProviderType = .Uber
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 45
    
    templateImageView.image = type.image
    templateImageView.backgroundColor = type.color
    
    templateLabel.text = type.rawValue
      // Do any additional setup after loading the view.
  }


}

extension PopUpTableViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
    return cell
  }
}
