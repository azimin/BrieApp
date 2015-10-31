//
//  ApiHelper.swift
//  Brie
//
//  Created by Vadim Drobinin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Foundation
import UberKit
import Alamofire
import SwiftyJSON

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    func makeShortAndBeautiful(self) {
        return self[0..<3].uppercaseString
    }
}

class VKAuth {
    class func addToList(id: String, ids: [Int]) -> VKRequest {
        return VKRequest(method: "friends.editList", andParameters: ["list_id": id,
                                                                    "add_user_ids": ids], andHttpMethod: "GET")
    }
    
    class func createList(name: String) -> VKRequest {
        return VKRequest(method: "friends.addList", andParameters: ["name": name], andHttpMethod: "GET")
    }
    
    class func getFriends() -> VKRequest {
        return VKRequest(method: "friends.get", andParameters: ["order": "name"], andHttpMethod: "GET")
    }
    
    
    class func getFriendsByList(id: String) -> VKRequest {
        return VKRequest(method: "friends.get", andParameters: ["order": "name", "list_id": id], andHttpMethod: "GET")
    }
    
    class func getFriendsLists() -> VKRequest {
        return VKRequest(method: "friends.getLists", andParameters: ["return_system": "0"], andHttpMethod: "GET")
    }
}

class UberAuth {
    
    class func openApp(latitude: Float, longitude: Float, dropOffName: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: "uber://?action=setPickup&pickup=my_location&pickup[nickname]=Your+place&dropoff[latitude]=\(latitude)&dropoff[longitude]=\(longitude)&dropoff[nickname]=\(dropOffName)&product_id=2733b11e-2060-401b-954b-01b41ff51999")!)
    }
    
    class func ETATOLocation(location: CLLocation) {
        UberKit.sharedInstance().getTimeForProductArrivalWithLocation(location) { (products, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print(products)
                for product in products {
                    if let product = product as? UberTime {
                        print("ID: \(product.productID)")
                        print("Name: \(product.displayName)")
                        print("Estimate: \(product.estimate)")
                        print("—————")
                    }
                }
            }
        }
    }
    
    class func getAllProducts(myCoord: CLLocation) {
        UberKit.sharedInstance().getProductsForLocation(myCoord) { (products, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print(products)
                for product in products {
                    if let product = product as? UberProduct {
                        print("ID: \(product.product_id)")
                        print("Description: \(product.product_description)")
                        print("Name: \(product.display_name)")
                        print("Capacity: \(product.capacity)")
                        print("—————")
                    }
                }
            }
        }
    }
    
    class func setUp() {
        UberKit.sharedInstance().serverToken = "ZyyBICknWEusJGQOr3T-P7wbWeACAf_MD2RxlY69"
        UberKit.sharedInstance().clientID =     "ubPe139HnMrEUyrBpFVYnpQPp2yAgcqS"
        UberKit.sharedInstance().clientSecret = "c7r-gKbGscAZ7zNEfAGSUaibUr3EU6UNDnHZSsVC"
        UberKit.sharedInstance().applicationName = "com.700km.Brie"
    }
}

class KudaGoAuth {
    class func eventsInRange(start: Int, end: Int, completion: (json: JSON) -> Void) {
        let base = "http://kudago.com/public-api/v1/events/"
        let location = "spb"
        let is_free = 1
        let categories = "exhibition,concert"
        
        let parameters: [String: AnyObject] = ["location": location, "actual_since": start, "actual_until": end, "is_free": is_free, "categories": categories]
        
        Alamofire.request(.GET, base, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let data):
                completion(json: JSON(data))
            case .Failure(let error):
                completion(json: JSON(["error": error.localizedDescription]))
            }
        }
    }
}

class IikoAuth {
    
}