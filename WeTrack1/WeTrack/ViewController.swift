//
//  ViewController.swift
//  WeTrack
//
//  Created by xuhelios on 1/13/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

import CoreData
import CoreLocation
import Alamofire



class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var major1: UILabel!
    @IBOutlet weak var major2: UILabel!
    @IBOutlet weak var minor1: UILabel!
    @IBOutlet weak var minor2: UILabel!
    
    //    let uuid = NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") as! UUID
    //    let majorx = 24890 as CLBeaconMajorValue
    //    let minorx = 6699 as CLBeaconMinorValue
    var locationManager : CLLocationManager!
    
    var residentList = [Residentx]()
    var beaconList = [Beaconx]()
    var regionList = [CLBeaconRegion]()
    var newRegionList = [CLBeaconRegion]()
    
    var region1 : CLBeaconRegion!
    var region2 : CLBeaconRegion!
    
    var isInit = true
    //    let uuid = NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") as! UUID
    //    let major : [CLBeaconMajorValue] = [58949, 23254,52689]
    //    let minor : [CLBeaconMinorValue] = [29933, 34430, 51570]
    //    let name = ["blue", "red", "yellow"]
    var n = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
//
        registerBackgroundTask()
        
        loadServerList()
        
        
        
        
        // registerBackgroundTask()
        //NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    //    deinit {
    //        NotificationCenter.default.removeObserver(self)
    //    }
    
    
    func restart(){
        
        if (self.n > 1){
            self.locationManager.stopMonitoring(for: region1)
            self.locationManager.stopMonitoring(for: region2)
        }
        
        if (self.n == 1){
            self.locationManager.stopMonitoring(for: region1)
        }
        self.isInit = true
        loadServerList()
        
    }
    func initt(){
        
        if (newRegionList.count > 0){
            regionList = newRegionList
            
            if (regionList.count > 1){
                region1 = regionList[0]
                region2 = regionList[1]
                
                self.locationManager.startMonitoring(for: region1)
                self.locationManager.startMonitoring(for: region2)
                
                name1.text = region1.identifier
                major1.text = String(describing: region1.major!)
                minor1.text = String(describing: region1.minor!)
                
                name2.text = region2.identifier
                major2.text = String(describing: region2.major!)
                minor2.text = String(describing: region2.minor!)
                
                updateTimer = Timer.scheduledTimer(timeInterval: 90.0, target: self, selector: #selector(changeRegion), userInfo: nil, repeats: true)
                
                self.i = 1
                
                
            }else{
                if (regionList.count == 1){
                    
                    region1 = regionList[0]
                    self.locationManager.startMonitoring(for: region1)
                    
                    name1.text = region1.identifier
                    major1.text = String(describing: region1.major!)
                    minor1.text = String(describing: region1.minor!)
                    name2.text = "NULL"
                    major2.text = "NULL"
                    minor2.text = "NULL"
                    updateTimer?.invalidate()
                    
                }
            }
        }else{
            
            updateTimer?.invalidate()
            
            name1.text = "NULL"
            major1.text = "NULL"
            minor1.text = "NULL"
            
            name2.text = "NULL"
            major2.text = "NULL"
            minor2.text = "NULL"
        }
        updateTimer = Timer.scheduledTimer(timeInterval: 150.0, target: self, selector: #selector(restart), userInfo: nil, repeats: true)
        self.n = regionList.count - 1
        
       
        
    }
    
    
    var updateTimer: Timer?
    var status = false
    var i = 1
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    //    func reinstateBackgroundTask() {
    //        if updateTimer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
    //            registerBackgroundTask()
    //        }
    //    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        //        print("Background task ended.")
        //        UIApplication.shared.endBackgroundTask(backgroundTask)
        //        backgroundTask = UIBackgroundTaskInvalid
    }
    
    func changeRegion(){
        
        // print("XYZ")
        //var j = 0
        
        switch (self.i){
            
        case (self.n):
          //  j = self.i - 1
            self.i = 0
            
            
        case ( 0 ):
            self.i = self.i + 1
         //   j = self.n
            
        default:
          //  j = self.i - 1
            self.i = self.i + 1
        }
        
        if (self.status == false){
            
            self.locationManager.stopMonitoring(for: region1)
            region1 = self.regionList[i]
            self.locationManager.startMonitoring(for: region1)
            
            name1.text = region1.identifier
            major1.text = String(describing: region1.major!)
            minor1.text = String(describing: region1.minor!)
            
        }else{
            
            self.locationManager.stopMonitoring(for: region2)
            region2 = self.regionList[i]
            self.locationManager.startMonitoring(for: region2)
            
            name2.text = region2.identifier
            major2.text = String(describing: region2.major!)
            minor2.text = String(describing: region2.minor!)
        }
        self.status = !self.status
        
    }
    
    func loadServerList(){
      
        let url = Constant.baseURL + "api/web/index.php/v1/resident?expand=beacons"
        
        if (self.isInit){
            newRegionList = [CLBeaconRegion]()
            residentList = [Residentx]()
            beaconList = [Beaconx]()
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            let statusCode = response.response?.statusCode
            print("connection code \(statusCode)")
            if (statusCode == 200){
                
                if let JSONS = response.result.value as? [[String: Any]] {
                    
                    for json in JSONS {
                        
                        let newResident = Residentx()
                        
                        newResident.status = (json["status"] as? Bool)!
                        
                        if ((newResident.status.hashValue != 0)){
                            
                            newResident.name = (json["fullname"] as? String)!
                            newResident.id = (json["id"] as? Int16)!
                            
                            if let beacon = json["beacons"] as? [[String: Any]] {
                                
                                for b in beacon{
                                    
                                    let newBeacon = Beaconx()
                                    newBeacon.uuid = (b["uuid"] as? String)!
                                    newBeacon.major = (b["major"] as? UInt16)!
                                    newBeacon.minor = (b["minor"] as? UInt16)!
                                    newBeacon.id = (b["id"] as? Int16)!
                                    print("\(newBeacon.id)")
                                    newBeacon.resident_id = newResident.id
                                    newBeacon.status = (b["status"] as? Bool)!
                                    if (newBeacon.status.hashValue != 0){
                                        
                                        let name = newResident.name + "#" + String(newBeacon.id) + "#" + String(newResident.id)
                                        print("** NAME \(name)")
                                        let uuid = NSUUID(uuidString: newBeacon.uuid) as! UUID
                                        let newRegion = CLBeaconRegion(proximityUUID: uuid, major: UInt16(newBeacon.major) as CLBeaconMajorValue, minor: UInt16(newBeacon.minor) as CLBeaconMajorValue, identifier: name )
                                        print("mornitor \(name)")
                                        self.newRegionList.append(newRegion)
                                        
                                    }
                                }
                            }
                        
                            self.residentList.append(newResident)
                        }
                    }
                }
                print("finish load")
                if (self.isInit){
                    self.updateTimer?.invalidate()
                    self.initt()
                    
                    self.isInit = false
                }
                
            }else{
                print("Connectionfail")
                self.updateTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.restart), userInfo: nil, repeats: true)
            }// if status
            
            
            
        }
//
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        
//        guard let context = delegate?.persistentContainer.viewContext else
//        {
//            print("contexterror")
//            return
//        }
        
    }
    

    
//    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion){
//        
//        print("@3: -____- state \(region.identifier)" )
//        switch state {
//        case .inside:
//            print(" -____- Inside \(region.identifier)");
//        case .outside:
//            print(" -____- Outside");
//        case .unknown:
//            print(" -____- Unknown");
//        default:
//            print(" -____-  default");
//        }
//    }
    
//    func report(){
//        
//        let url = Constant.baseURL + "api/web/index.php/v1/location-history/create"
//        
//        if (self.isInit){
//            newRegionList = [CLBeaconRegion]()
//            residentList = [Residentx]()
//            beaconList = [Beaconx]()
//        }
//        
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
//        }
//    }

}
