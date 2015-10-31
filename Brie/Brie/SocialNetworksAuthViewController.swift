//
//  SocialNetworksAuthViewController.swift
//  Brie
//
//  Created by Vadim Drobinin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class SocialNetworksAuthViewController: UIViewController {

//    func VKAuth() {
//        VKSdk.authorize([VK_PER_OFFLINE, VK_PER_WALL, VK_PER_FRIENDS], revokeAccess: true)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//      
//        VKSdk.initializeWithDelegate(self, andAppId: "5128197")
//        if VKSdk.wakeUpSession() {
//            print("AUTHORIZED AND READY TO GO")
//        } else {
//            print("LET'S AUTHORIZE")
//            
//        }
//    }
//
//}
//
//extension SocialNetworksAuthViewController: VKSdkDelegate {
//    func vkSdkNeedCaptchaEnter(captchaError: VKError) {
//        println("Need captcha")
//    }
//    
//    func vkSdkTokenHasExpired(expiredToken: VKAccessToken) {
//        println("Token has exp")
//    }
//    
//    func vkSdkUserDeniedAccess(authorizationError: VKError) {
//        println("Access denied")
//    }
//    
//    func vkSdkShouldPresentViewController(controller: UIViewController) {
//        println("Should present VC")
//        presentViewController(controller, animated: true) { () -> Void in
//            println("Success!")
//        }
//    }
//    
//    func vkSdkReceivedNewToken(newToken: VKAccessToken) {
//        println("Succesfully authorized! User ID:")
//        println(VKSdk.getAccessToken().userId)
//        self.performSegueWithIdentifier("Are You Couch segue", sender: nil)
//    }
}