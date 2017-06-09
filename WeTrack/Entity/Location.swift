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
    init(arr: [String : String]) {
        self.id = arr["id"] ?? ""
        self.beacon_id = arr["beacon_id"] ?? ""
        self.locator_id = arr["locator_id"] ?? ""
        self.user_id = arr["user_id"] ?? ""
        self.longitude = arr["longitude"] ?? ""
        self.latitude = arr["latitude"] ?? ""
        self.address = arr["address"] ?? ""
        self.created_at = arr["created_at"] ?? ""
    }
}
