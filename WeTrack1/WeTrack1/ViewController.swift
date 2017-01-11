//
//  ViewController.swift
//  WeTrack1
//
//  Created by xuhelios on 1/9/17.
//  Copyright © 2017 sg. All rights reserved.
//


import CoreLocation

import UIKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    

//    let uuid = NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") as! UUID
//    let majorx = 24890 as CLBeaconMajorValue
//    let minorx = 6699 as CLBeaconMinorValue
    var locationManager : CLLocationManager!
    
    var regionList = [CLBeaconRegion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        //var beaconRegion = CLBeaconRegion(proximityUUID: self.uuid, major: self.major, minor: self.minor, identifier: "Conchimxanh")
        loadData()
        
        
        //self.locationManager.startMonitoring(for: beaconRegion)
        
        //self.pro.text = "Runing...."
   
        //self.loadItems()
    }

    let major : [CLBeaconMajorValue] = [58949, 23254,24890]
    let minor : [CLBeaconMinorValue] = [29933, 34430, 6699]
    let name = ["blue", "red", "yellow"]
    let n = 2
    
//    var region1 : CLBeaconRegion!
//    var region2 : CLBeaconRegion!
    
    let uuid = NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") as! UUID
    func loadData(){
        
        //let uuid = NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") as! UUID
//        let major1 = self.major[self.i  - 1] as CLBeaconMajorValue
//        let minor1 = self.minor[self.i - 1] as CLBeaconMinorValue
//        let name1 = self.name[self.i - 1]
//        region1 = CLBeaconRegion(proximityUUID: uuid, major: major1, minor: minor1, identifier: name1)
//        let newmajor2 = self.major[self.i] as CLBeaconMajorValue
//        let minor2 = self.minor[self.i] as CLBeaconMinorValue
//        let name2 = self.name[self.i]

        for j in 0...self.n {
           
            let newRegion = CLBeaconRegion(proximityUUID: uuid, major: self.major[j], minor: self.minor[j], identifier: self.name[j])
            
            regionList.append(newRegion)
        }
//        region1 = self.regionList[0]
//        region2 = self.regionList[1]
        
        name1.text = self.name[0]
        major1.text = String(self.major[0])
        minor1.text = String(self.minor[0])
        
        name2.text = self.name[1]
        major2.text = String(self.major[1])
        minor2.text = String(self.minor[1])
        
        self.locationManager.startMonitoring(for: self.regionList[0])
        self.locationManager.startMonitoring(for: self.regionList[1])
        
        let timer1 = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: Selector("changeRegion"), userInfo: nil, repeats: true)
    }
    
    var status = false
    var i = 1

    func changeRegion(){
        
       // print("XYZ")
        var j = 0
        
        switch (self.i){
            
            case (self.n):
                j = self.i - 1
                self.i = 0
            
      
            case ( 0 ):
                self.i = self.i + 1
                j = self.n
            
        default:
            j = self.i - 1
            self.i = self.i + 1
        }
        
        self.locationManager.stopMonitoring(for: self.regionList[j])
        self.locationManager.startMonitoring(for: self.regionList[i])
        print("Stop \(self.name[j])   Start  \(self.name[i])")
        
        setupView(k: i)
    }
    
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var major1: UILabel!
    @IBOutlet weak var major2: UILabel!
    @IBOutlet weak var minor1: UILabel!
    @IBOutlet weak var minor2: UILabel!
    
    func setupView(k: Int){
        print("check \(k)   \(self.status)")
        if (self.status == false){
            
            name1.text = self.name[k]
            major1.text = String(self.major[k])
            minor1.text = String(self.minor[k])
            
        }else{
        
            name2.text = self.name[k]
            major2.text = String(self.major[k])
            minor2.text = String(self.minor[k])
        }
        self.status = !self.status
        
    }
//    
//    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
//        print("Failed monitoring region: \(error)")
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error?) {
//        print("Location manager failed: \(error)")
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        
//        //self.detailTextLabel!.text = "Location: \(self.name(for: self.item.lastSeenBeacon.proximity))"
//
//    }

    
}


