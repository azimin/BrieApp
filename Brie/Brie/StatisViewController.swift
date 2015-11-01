//
//  StatisViewController.swift
//  Brie
//
//  Created by Alex Zimin on 01/11/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class StatisViewController: UIViewController {

  var event: EventEntity!
  @IBOutlet weak var templateImageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      if event.name.hasPrefix("Принимать") || event.name.hasSuffix("shower")  {
        templateImageView.image = UIImage(named: "Template")
      } else {
        templateImageView.image = UIImage(named: "Template_2")
      }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
