//
//  SocialNetworksAuthViewController.swift
//  Brie
//
//  Created by Vadim Drobinin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class SocialNetworksAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        VKSdk.initializeWithDelegate(self, andAppId: "5128197")
        if VKSdk.wakeUpSession() {
            print("")
        }
    }

}
