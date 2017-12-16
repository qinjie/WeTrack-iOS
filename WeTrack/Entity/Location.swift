//
//  Location.swift
//  WeTrack
//
//  Created by Anh Tuan on 6/8/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import SwiftyJSON

class Location: NSObject {
    var id : String
    var beacon_id : String
    var locator_id : String
    var user_id : String
    var longitude : String
    var latitude : String
    var address : String
    var created_at : String
    
    init(json : JSON) {
        self.id = json["id"].stringValue
        self.beacon_id = json["beacon_id"].stringValue
        self.locator_id = json["locator_id"].stringValue
        self.user_id = json["user_id"].stringValue
        self.longitude = json["longitude"].stringValue
        self.latitude = json["latitude"].stringValue
        self.address = json["address"].stringValue
        self.created_at = json["created_at"].stringValue
    }
    init(arr: [String : Any]) {
        self.id = String(arr["id"] as? Int ?? 0)
        self.beacon_id = String(arr["beacon_id"] as? Int ?? 0)
        self.locator_id = String(arr["locator_id"] as? Int ?? 0)
        self.user_id = String(arr["user_id"] as? Int ?? 0)
        self.longitude = arr["longitude"] as? String ?? ""
        self.latitude = arr["latitude"] as? String ?? ""
        self.address = arr["address"] as? String ?? ""
        self.created_at = arr["created_at"] as? String ?? ""
    }
}
