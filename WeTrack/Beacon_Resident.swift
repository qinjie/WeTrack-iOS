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
    dynamic var seen: String = ""
    dynamic var status: Bool = true
    dynamic var uuid: String = ""
    
    //Set primary key
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    required init() {
//        uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
//        major = 0
//        id = 0
//        minor = 0
//        status = true
//        resident_id = 0
//        name = "Helios"
//        photopath = "uploads/human_images/no_image.png"
//        
//        detect = false
//        
//        seen = "00"
//    }
//    
//    init(beaconId: String, det: Bool, time: String){
//        
//        if (GlobalData.beaconList.contains(where: {$0.id.description == beaconId})){
//            let x =  GlobalData.beaconList.first(where: {$0.id.description == beaconId})
//            
//            uuid = (x?.uuid)!
//            major = (x?.major)!
//            id = (x?.id)!
//            minor = (x?.minor)!
//            status = true
//            resident_id = (x?.resident_id)!
//            name = (x?.name)!
//            photopath = (x?.photopath)!
//            
//            detect = det
//            
//            seen = time
//            
//        }
//            
//        else{
//            uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
//            major = 0
//            id = 0
//            minor = 0
//            status = true
//            resident_id = 0
//            name = "Helios"
//            photopath = "uploads/human_images/no_image.png"
//            
//            detect = false
//            
//            seen = "00"
//        }
//    }
    
//    required init(value: Any, schema: RLMSchema) {
//        fatalError("init(value:schema:) has not been implemented")
//    }
//    
//    required init(value: Any, schema: RLMSchema) {
//        fatalError("init(value:schema:) has not been implemented")
//    }

    
}


class Resident: Object{
    dynamic var name: String = "Zerry"
    dynamic var id: Int32 = 0
    dynamic var photo: String = ""
    dynamic var nric: String = ""
    dynamic var report: String = ""
    dynamic var status: Bool = true
    dynamic var remark: String = "00"
    dynamic var seen: String = "00"
    dynamic var dob: String = "00"
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

class LocationHistory{
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
    
}
