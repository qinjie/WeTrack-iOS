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
    static let URLreport = baseURL + "api/web/index.php/v1/location-history"
    static let URLmissing = baseURL + "api/web/index.php/v1/resident/missing?expand=beacons,relatives,locations"
    static let restartTime = 30.0
    static let photoURL = "http://128.199.93.67/WeTrack/backend/web/"
}

struct GlobalData{
    static var residentList = Array(realm.objects(Resident.self))
    static var history = [Beacon]()
    static var nearMe =  [Resident]()
  //  static var findB = [String: Beacon]()
    //static var nearbyList = [Beacon]()
 
    static var beaconList = Array(realm.objects(Beacon.self))
    static var currentRegionList = [CLBeaconRegion]()
    
}




