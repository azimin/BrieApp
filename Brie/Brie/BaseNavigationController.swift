//
//  TABaseNavigationController.swift
//  Target-App
//
//  Created by Alex Zimin on 05/04/15.
//  Copyright (c) 2015 Alex & Vadim. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.translucent = false
        
        updateUI()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateUI() {
        let textAttributes = [NSForegroundColorAttributeName: UIColor.navigationBarTextColor]
        self.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationBar.setBackgroundImage(UIImage.imageFromColor(UIColor.navigationBarColor), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.tintColor = UIColor.navigationBarTextColor
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    var isWithShadow: Bool = false {
        didSet {
            if isWithShadow {
                self.navigationBar.shadowImage = nil
            } else {
                self.navigationBar.shadowImage = UIImage()
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
      if self.navigationBarHidden {
        return UIStatusBarStyle.Default
      } else {
        return UIStatusBarStyle.LightContent
      }
    }

}
