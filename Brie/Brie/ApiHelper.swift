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
    func setUp() {
        UberKit.sharedInstance().serverToken = "ZyyBICknWEusJGQOr3T-P7wbWeACAf_MD2RxlY69"
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