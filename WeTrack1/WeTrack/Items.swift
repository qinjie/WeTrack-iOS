//
//  Items.swift
//  WeTrack
//
//  Created by xuhelios on 1/13/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import Foundation
struct Constant{
    static let baseURL = "http://128.199.93.67/WeTrack/"
    
}

class Beaconx{
    var uuid: String
    var major: UInt16
    var minor: UInt16
    var id: Int16
    var resident_id: Int16
    var status: Bool
    init() {
       uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
       major = 0
       id = 0
       minor = 0
       status = false
       resident_id = 0
    }

}

class Residentx{
    var name: String
    var id: Int16
    var status: Bool
    init() {
        name = "Zerry"

        id = 0

        status = false
    }
    
}
