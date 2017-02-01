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
    static let restartTime = 60.0
    static let photoURL = "http://128.199.93.67/WeTrack/backend/web/"
}

struct GlobalData{
    static var residentList = [Resident]()
    static var history = [Beacon]()
    static var nearMe =  [Resident]()
  //  static var findB = [String: Beacon]()
    //static var nearbyList = [Beacon]()
    
    static var beaconList = [Beacon]()
    static var currentRegionList = [CLBeaconRegion]()
    
}




