//
//  SocialNetworksAuthViewController.swift
//  Brie
//
//  Created by Vadim Drobinin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Foundation
import UberKit

func nsdateToUnix(date: NSDate) -> Int {
  return Int(date.timeIntervalSince1970)
}

//let myCoord = CLLocation(latitude: 37.7833, longitude: -122.4167)
let myCoord = CLLocation(latitude: 59.95064370000001, longitude: 30.291187599999997)

class SocialNetworksAuthViewController: UIViewController {

    let idsOfFriends = [
        8796171,
        33399749,
        10731954,
        212846399,
        140382302,
        21273568
    ] // FOR TEST ONLY
    
    func VKAuthtorize() {
        VKSdk.authorize([VK_PER_OFFLINE, VK_PER_WALL, VK_PER_FRIENDS], revokeAccess: true)
    }
    
    func addToList() {
        let request = VKAuth.addToList("5", ids: idsOfFriends)
        request.executeWithResultBlock({ (response) -> Void in
            print("Add friends")
            if let resp = JSON(response.json).int {
                print(resp)
            }
            }, errorBlock: { (error) -> Void in
                print(error)
        })
    }
    
    func createList() {
        let request = VKAuth.createList("BrieApp")
        request.executeWithResultBlock({ (response) -> Void in
            print("Created list")
            if let resp = JSON(response.json).dictionary {
                print(resp)
            }
            }, errorBlock: { (error) -> Void in
                print(error)
        })
    }

    func getFriends() {
        let request = VKAuth.getFriends()
        request.executeWithResultBlock({ (response) -> Void in
            if let resp = JSON(response.json).dictionary {
                print("Getting Friends")
                print(resp["items"])
            }
            }, errorBlock: { (error) -> Void in
                print(error)
        })
    }
    
    func getLists() {
        let request = VKAuth.getFriendsLists()
        request.executeWithResultBlock({ (response) -> Void in
            if let resp = JSON(response.json).dictionary {
                print("Getting Lists")
                print(resp["items"])
            }
            }, errorBlock: { (error) -> Void in
                print(error)
        })
    }
    
    func increaseByHours(date: NSDate, hours: Int) -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(
            .Hour,
            value: hours,
            toDate: date,
            options: NSCalendarOptions(rawValue: 0))!
    }
    
    func eventsInRange(start: NSDate, end: NSDate) {
        let startUnix = nsdateToUnix(start)
        let endUnix = nsdateToUnix(end)
        KudaGoAuth.eventsInRange(startUnix, end: endUnix) { (json) -> Void in
            print(json)
        }
    }
    
    func getFriendsByList(id: String) {
        let request = VKAuth.getFriendsByList(id)
        request.executeWithResultBlock({ (response) -> Void in
            if let resp = JSON(response.json).dictionary {
                print("Getting Friends by list \(id)")
                print(resp["items"])
            }
            }, errorBlock: { (error) -> Void in
                print(error)
        })
    }
    
    override func az_tabBarItemContentView() -> AZTabBarItemView {
        let cell = BrieTabBarItem().az_loadFromNibIfEmbeddedInDifferentNib()
        cell.type = BrieTabBarItem.BrieTabBarItemType.Setting
        return cell
    }
    
    func processVK() {
        VKSdk.initializeWithDelegate(self, andAppId: "5128197")
        if VKSdk.wakeUpSession() {
            print("AUTHORIZED AND READY TO GO")
        } else {
            print("LET'S AUTHORIZE")
            VKAuthtorize()
        }
    }
    
    func processKudaGO() {
        eventsInRange(NSDate(), end: increaseByHours(NSDate(), hours: 2))
    }
    
    
    func processUber() {
        UberAuth.setUp()
        UberKit.sharedInstance().delegate = self
        
        
        //UberAuth.ETATOLocation(myCoord)
        UberAuth.openApp(59.9358, longitude: 30.3256, dropOffName: "VK+Office")
    }
    
    func startUberActivity() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        processVK()
        processKudaGO()
        processUber()
    }
}

extension SocialNetworksAuthViewController: UberKitDelegate {
    func uberKit(uberKit: UberKit!, didReceiveAccessToken accessToken: String!) {
        print("Success!")
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "uberAccessToken")
        startUberActivity()
    }
    
    func uberKit(uberKit: UberKit!, loginFailedWithError error: NSError!) {
        print("Uber Auth failed with \(error.localizedDescription)")
    }
}


extension SocialNetworksAuthViewController: VKSdkDelegate {
    func vkSdkNeedCaptchaEnter(captchaError: VKError) {
        print("Need captcha")
    }
    
    func vkSdkTokenHasExpired(expiredToken: VKAccessToken) {
        print("Token has exp")
    }
    
    func vkSdkUserDeniedAccess(authorizationError: VKError) {
        print("Access denied")
    }
    
    func vkSdkShouldPresentViewController(controller: UIViewController) {
        print("Should present VC")
        presentViewController(controller, animated: true) { () -> Void in
            print("Success!")
        }
    }
    
    func vkSdkReceivedNewToken(newToken: VKAccessToken) {
        print("Succesfully authorized! User ID:")
        print(VKSdk.getAccessToken().userId)
//        self.performSegueWithIdentifier("", sender: nil)
    }
}