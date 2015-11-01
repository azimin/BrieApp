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

//NSDate().getMonth().makeShortAndBeautiful()
extension NSDate {
  func getMonth() -> String {
    let formatter = NSDateFormatter()
    formatter.dateStyle = NSDateFormatterStyle.LongStyle
    formatter.dateFormat = "MMMM"
    
    return formatter.stringFromDate(self)
  }
}

extension String {
  subscript (r: Range<Int>) -> String {
    get {
      let startIndex = self.startIndex.advancedBy(r.startIndex)
      let endIndex = startIndex.advancedBy(r.endIndex - r.startIndex)
      return self[Range(start: startIndex, end: endIndex)]
    }
  }
  
  func makeShortAndBeautiful() -> String {
    return self[0..<3].uppercaseString
  }
}

class IikoAuth {
  
  // Untested
  class func getRestaurantMenu(completion: (restaurants: [JSON]) -> Void) {
    let token = NSUserDefaults.standardUserDefaults().objectForKey("iiko_auth_token") as! String
    Alamofire.request(.GET, "https://iiko.biz:9900/api/0/nomenclature/e47efbb3-8b80-4727-9f8b-3600d0b4c5d8?access_token=\(token)").responseString { (response) -> Void in
      switch response.result {
      case .Success(let data):
        completion(restaurants: JSON(data).dictionaryValue["products"]?.arrayValue ?? [JSON("error")])
        // Iterate for "name", "description", "price",
        break
      case .Failure(let error):
        completion(restaurants: [JSON("\(error)")])
        break
      }
    }
  }
  
  // Untested
  class func getToken(completion: (token: String) -> Void) {
    Alamofire.request(.GET, "https://iiko.biz:9900/api/0/auth/access_token?user_id=hakatonVk&user_secret=hakatonTest").responseString { (response) -> Void in
      switch response.result {
      case .Success(let data):
        completion(token: data)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "iiko_auth_token")
        break
      case .Failure(let error):
        completion(token: "error")
        break
      }
    }
  }
}

class VKAuth {
    class func getNotesByURL() -> VKRequest {
        return VKRequest(method: "notes.get", andParameters: ["note_ids": NSUserDefaults.standardUserDefaults().integerForKey("noteID")], andHttpMethod: "GET")
    }
    
    class func createNoteWithData(data: String) -> VKRequest {
        return VKRequest(method: "notes.add", andParameters: ["title": "BrieApp", "text": data], andHttpMethod: "GET")
    }
    
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
  
  class func priceForRide(from: CLLocation, to: CLLocation, isEndLocation: Bool) {
    let uber = PopUpProviderItem()
    PopUpHelper.sharedInstance.type = .Uber
    PopUpHelper.sharedInstance.item = uber
    
    
    ETATOLocation(from, completion: { (value) -> () in
      
      if isEndLocation {
        UberKit.sharedInstance().getPriceForTripWithStartLocation(from, endLocation: to) { (price, response, error) -> Void in
          if error == nil {
            if price.count > 0 {
              if let obj = price[0] as? UberPrice {
                uber.infoDictionary["Trip time"] = "\(Int(round(Float(obj.duration) / 60))) min"
                uber.infoDictionary["Price"] = "\(obj.estimate)"
                uber.infoDictionary["Distance"] = "\(obj.distance)"
              }
            }
          }
          
          uber.isLoading = false
        }
      }
      
      
      
      if let value = value {
        uber.infoDictionary.setObjectIfNeeded("\(Int(round(value / 60))) min", forKey: "Waiting time")
        uber.actions = ["Request"]
      }
      
      uber.isLoading = isEndLocation
    })
  }
  
  class func ETATOLocation(location: CLLocation, completion: (value: Float?) -> ()) {
    UberKit.sharedInstance().getTimeForProductArrivalWithLocation(location) { (products, response, error) -> Void in
      if error != nil {
        print(error)
        completion(value: nil)
      } else {
        print(products)
        if let product = products.first as? UberTime {
          print("ID: \(product.productID)")
          print("Name: \(product.displayName)")
          print("Estimate: \(product.estimate)")
          print("—————")
          completion(value: product.estimate)
        } else {
          completion(value: nil)
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
