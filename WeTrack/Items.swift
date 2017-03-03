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
    // static let URLlogin = baseURL + "api/web/index.php/v1/user/login"
    static let URLlogin = baseURL + "api/web/index.php/v1/user/login-email"
    static let URLreport = baseURL + "api/web/index.php/v1/location-history"
    static let URLmissing = baseURL + "api/web/index.php/v1/resident/missing?expand=beacons,relatives,locations"
    static let URLall = baseURL + "api/web/index.php/v1/resident?expand=relatives,beacons,locations,locationHistories"
    static let URLcreateDeviceTk = baseURL + "api/web/index.php/v1/device-token/new"
    static let URLdelDeviceTk = baseURL + "api/web/index.php/v1/device-token/del"
    static let URLstatus = baseURL + "api/web/index.php/v1/resident/status"
    static var device_token = ""
    
    static let restartTime = 60.0
    static let photoURL = "http://128.199.93.67/WeTrack/backend/web/"
    static var token = ""
    static var username = ""
    static var role = 40
    static var user_id : Int = 0
    static var email = "np@gmail.com"
    static var noti = true
    static var isScanning = true
    static var userphoto = URL(string: "")
    
    static var isLogin = false
    
}

struct GlobalData{
    static var missingList = [Resident]()
    static var allResidents = [Resident]()
    static var relativeList = [Resident]()
    static var history = [Beacon]()
    static var nearMe =  [Resident]()
    //  static var findB = [String: Beacon]()
    //static var nearbyList = [Beacon]()
    
    static var beaconList = [Beacon]()
    static var currentRegionList = [CLBeaconRegion]()
    
}




