//
//  PopUpViewController.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

  @IBOutlet weak var contrainerViewController: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      contrainerViewController.layer.masksToBounds = true
      contrainerViewController.layer.cornerRadius = 12
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    TAWindowShower.sharedInstance.closeTopWindow()
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
