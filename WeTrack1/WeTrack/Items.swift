//
//  Items.swift
//  WeTrack
//
//  Created by xuhelios on 1/13/17.
//  Copyright © 2017 beacon. All rights reserved.
//
import CoreLocation
import Foundation

struct Constant{
    static let baseURL = "http://128.199.93.67/WeTrack/"
    static let restartTime = 250.0
    static let photoURL = "http://128.199.93.67/WeTrack/backend/web/"
}

struct GlobalData{
    static var residentList = [Residentx]()
    static var history = [Beaconx]()
    static var findR = [String: Residentx]()
    static var findB = [String: Beaconx]()
    

    static var beaconList = [Beaconx]()
    static var currentRegionList = [CLBeaconRegion]()
    
}


class Beaconx{
    var seen: Date
    var name: String
    var uuid: String
    var major: Int32
    var minor: Int32
    var id: Int32
    var resident_id: Int32
    var status: Bool
    var photopath: String
    var detect: Bool
    init() {
       uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
       major = 0
       id = 0
       minor = 0
       status = true
       resident_id = 0
       name = "Helios"
       photopath = "uploads/human_images/no_image.png"
        
       detect = false
    
       seen = Date()
    }
    
    init(beaconId: String, userId: String, d: Bool, day: Date) {
        
        let x = GlobalData.findB[beaconId]! as Beaconx
        
        let info = x.name.components(separatedBy: "#")
        
        
        uuid = x.uuid
        major = x.major
        id = x.id
        minor = x.minor
        status = x.status
        name = x.name
        
        resident_id = Int32(info[2])!
        
        photopath = x.photopath
        
        detect = d
        seen = day
    }

}

class Residentx{
    var name: String
    var id: Int32
    var photo: String
    var status: Bool
    init() {
        name = "Zerry"

        id = 0
        
        photo = "uploads/human_images/no_image.png"
        
        status = false
    }
    
}
