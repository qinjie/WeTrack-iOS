//
//  Beacon.swift
//  WeTrack
//
//  Created by xuhelios on 1/31/17.
//  Copyright © 2017 beacon. All rights reserved.
//
import Foundation
import RealmSwift

class Beacon: Object{
    
    dynamic var detect: Bool = true
    dynamic var id: Int32 = 0
    dynamic var major: Int32 = 0
    dynamic var minor: Int32 = 0
    dynamic var name: String = ""
    dynamic var photopath: String = ""
    dynamic var resident_id: Int32 = 0
    dynamic var report: String = ""
    dynamic var status: Bool = true
    dynamic var uuid: String = ""
    
    //Set primary key
    override static func primaryKey() -> String? {
        return "id"
    }
    

    
}


class Resident: Object{
    dynamic var name: String = "Test"
    dynamic var id: Int32 = 0
    dynamic var photo: String = ""
    dynamic var nric: String = ""
    dynamic var report: String = ""
    dynamic var status: Bool = true
    dynamic var remark: String = "No report"
    dynamic var dob: String = "00"
    dynamic var address: String = "No report"
    dynamic var lat: String = "00"
    dynamic var long: String = "00"
    dynamic var isRelative: Bool = false
//    required init() {
//        name = "Zerry"
//        
//        id = 0
//        
//        photo = "uploads/human_images/no_image.png"
//        
//        status = false
//    }
//    init(Name: String, Id: String, Status: Bool, Photo: String) {
//        name = Name
//        
//        id = Int32(Id)!
//        
//        photo = Photo
//        
//        status = Status
//    }


}


class LocationHistory: NSObject, NSCoding {
    
    var beaconId: String = "123"
    var userId: String = "68"
    var lat: String = "1.0"
    var long: String = "123"
    
    init(bId: String, uId: String, newlat: String, newlong: String){
        beaconId = bId
        userId = uId
        lat = newlat
        long = newlong
    }

    
    required init(coder aDecoder: NSCoder) {
        beaconId = aDecoder.decodeObject(forKey: "beaconId") as? String ?? ""
        userId = aDecoder.decodeObject(forKey: "userId") as? String ?? ""
        lat = aDecoder.decodeObject(forKey: "lat") as? String ?? ""
        long = aDecoder.decodeObject(forKey: "long") as? String ?? ""
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(beaconId, forKey: "beaconId")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(long, forKey: "long")
    }
}


