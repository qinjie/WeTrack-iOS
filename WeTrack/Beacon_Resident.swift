//
//  Beacon.swift
//  WeTrack
//
//  Created by xuhelios on 1/31/17.
//  Copyright © 2017 beacon. All rights reserved.
//
import Foundation


class Beacon{
    
    var detect: Bool = true
    var id: Int = 0
    var major: Int32 = 0
    var minor: Int32 = 0
    var name: String = ""
    var photopath: String = ""
    var resident_id: Int = 0
    var report: String = ""
    var status: Bool = true
    var uuid: String = ""
    

    

    
}


class Resident: NSObject, NSCoding {
    var name: String = "Test"
    var id: String = "0"
    var photo: String = ""
    var nric: String = ""
    var report: String = ""
    var status: Bool = true
    var remark: String = "No report"
    var dob: String = "00"
    var address: String = "No report"
    var lat: String = "00"
    var long: String = "00"
    var isRelative: Bool = false
    
    override init(){
        
        name = "Test"
        id = "0"
        photo = ""
        nric = ""
        report = ""
        status = true
        remark = "No report"
        dob = "00"
        address = "No report"
        lat = "00"
        long = "00"
        isRelative = false
        
    }
//    
//    init(rName: String, rId: Int32, rPhoto: String, rNric: String, rReport: String, rStatus: Bool, rRemark: String, rDob: String, rAddress: String, rLat: String, rLong: String, rIsRelative: Bool){
//        name = rName
//        id = rId
//        photo = rPhoto
//        nric = rNric
//        report = rReport
//        status = rStatus
//        remark = rRemark
//        dob = rDob
//        address = rAddress
//        lat = rLat
//        long = rLong
//        isRelative = rIsRelative
//
//    }
    
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        id = aDecoder.decodeObject(forKey: "id") as? String ?? "0"
        photo = aDecoder.decodeObject(forKey: "photo") as? String ?? ""
        nric = aDecoder.decodeObject(forKey: "nric") as? String ?? ""
        report = aDecoder.decodeObject(forKey: "report") as? String ?? ""
        status = aDecoder.decodeObject(forKey: "status") as? Bool ?? true
        remark = aDecoder.decodeObject(forKey: "remark") as? String ?? ""
        dob = aDecoder.decodeObject(forKey: "dob") as? String ?? ""
        address = aDecoder.decodeObject(forKey: "address") as? String ?? ""
        lat = aDecoder.decodeObject(forKey: "lat") as? String ?? ""
        long = aDecoder.decodeObject(forKey: "long") as? String ?? ""
        isRelative = aDecoder.decodeObject(forKey: "isRelative") as? Bool ?? false
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(photo, forKey: "photo")
        aCoder.encode(nric, forKey: "nric")
        aCoder.encode(report, forKey: "report")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(remark, forKey: "remark")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(long, forKey: "long")
        aCoder.encode(isRelative, forKey: "isRelative")
    }


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


