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



class ViewController: UIViewController, CLLocationManagerDelegate{
    
  
    
    //    let uuid = NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") as! UUID
    //    let majorx = 24890 as CLBeaconMajorValue
    //    let minorx = 6699 as CLBeaconMinorValue
    
    var locationManager : CLLocationManager!
    
    var residentList = [Resident]()
    var beaconList = [Beacon]()
    var currentRegionList = [CLBeaconRegion]()
    var newRegionList = [CLBeaconRegion]()
    
    var region1 : CLBeaconRegion!
    var region2 : CLBeaconRegion!
    

    var n = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()

        registerBackgroundTask()
        
        loadServerList()
        
        updateTimer = Timer.scheduledTimer(timeInterval: Constant.restartTime, target: self, selector: #selector(loadServerList), userInfo: nil, repeats: true)
        
        // registerBackgroundTask()
        //NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    
    //    deinit {
    //        NotificationCenter.default.removeObserver(self)
    //    }

    
    func switchMornitoringList(){
        
        if (self.n > 1){
            
            for uniqueRegion in currentRegionList{
                
                self.locationManager.stopMonitoring(for: uniqueRegion)
            }
            
        }
        
        if (newRegionList.count > 0){
            
            currentRegionList = newRegionList
            
            if (currentRegionList.count <= 20){
                
                for uniqueRegion in currentRegionList{
                    
                    self.locationManager.startMonitoring(for: uniqueRegion)
                }
            }else{
                // group beacon
            }
        }
        self.n = newRegionList.count
        
    }
    
    func loadServerList(){
      
        let url = Constant.baseURL + "api/web/index.php/v1/resident?expand=beacons"
        
        newRegionList = [CLBeaconRegion]()
        residentList = [Resident]()
        beaconList = [Beacon]()
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            let statusCode = response.response?.statusCode
            print("connection code \(statusCode)")
            if (statusCode == 200){
                
                if let JSONS = response.result.value as? [[String: Any]] {
                    
                    for json in JSONS {
                        
                        let newResident = Resident()
                        
                        newResident.status = (json["status"] as? Bool)!
                        
                        if ((newResident.status.hashValue != 0)){
                            
                            newResident.name = (json["fullname"] as? String)!
                            newResident.id = (json["id"] as? Int32)!
                            
                            if let beacon = json["beacons"] as? [[String: Any]] {
                                
                                for b in beacon{
                                    
                                    let newBeacon = Beacon()
                                    newBeacon.uuid = (b["uuid"] as? String)!
                                    newBeacon.major = (b["major"] as? Int32)!
                                    newBeacon.minor = (b["minor"] as? Int32)!
                                    newBeacon.id = (b["id"] as? Int32)!
                                    print("\(newBeacon.id)")
                                    newBeacon.resident_id = newResident.id
                                    newBeacon.status = (b["status"] as? Bool)!
                                    if (newBeacon.status.hashValue != 0){
                                        
                                        newBeacon.name = newResident.name + "#" + String(newBeacon.id) + "#" + String(newResident.id)
                                        print("** NAME \(newBeacon.name)")
                                        let uuid = NSUUID(uuidString: newBeacon.uuid) as! UUID
                                        let newRegion = CLBeaconRegion(proximityUUID: uuid, major: UInt16(newBeacon.major) as CLBeaconMajorValue, minor: UInt16(newBeacon.minor) as CLBeaconMajorValue, identifier: newBeacon.name )
                                        print("mornitor \(newBeacon.name)")
                                        self.newRegionList.append(newRegion)
                                        self.beaconList.append(newBeacon)
                                        
                                    }
                                }
                            }
                            
                            self.residentList.append(newResident)
                        }
                    }
                }
                print("finish load")
                var notification = UILocalNotification()
                notification.alertBody = "Load new list"
                notification.soundName = "Default"
                UIApplication.shared.presentLocalNotificationNow(notification)
                
                self.switchMornitoringList()
                self.saveCurrentListLocal()
                
            }else{
                // when connecting internet is fail, the app uses the lastest local data to run
                // the new data will be update for both app and local data
                
                self.loadLocal()
                print("beaconlistwhen loadlocal \(self.beaconList.count)")
                
                
            }// if status
            
        }
       
    }
    
    
    func loadLocal(){
         GlobalData.beaconList = Array(realm.objects(Beacon))
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        
//        if let context = delegate?.persistentContainer.viewContext {
//            
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Beacon")
//            request.returnsObjectsAsFaults = false
//            
//            do {
//                beaconList = try! context.fetch(request) as! [Beacon]
//                
//                for newBeacon in beaconList{
//                    
//                    let uuid = NSUUID(uuidString: newBeacon.uuid) as! UUID
//                    let newRegion = CLBeaconRegion(proximityUUID: uuid, major: UInt16(newBeacon.major) as CLBeaconMajorValue, minor: UInt16(newBeacon.minor) as CLBeaconMajorValue, identifier: newBeacon.name )
//                    print("mornitor \(newBeacon.name)")
//                    self.newRegionList.append(newRegion)
//                    self.beaconList.append(newBeacon)
//                    
//                }
//                
//            }catch{
//                fatalError("Failed to fetch \(error)")
//            }
//            
//            //subjects = subjects?.sorted(by: {$0.name!.compare($1.name! as String) == .orderedAscending})
//        }
//        
    }
    
    func saveCurrentListLocal(){
        
        if (currentRegionList.count == 0 || beaconList.count == 0){
            return
        }
        
        clearLocal()
        
        try! realm.write {
            realm.add(GlobalData.beaconList)
        }
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        
//        if let context = delegate?.persistentContainer.viewContext {
//            
//            for b in beaconList {
//                
//                let newBeacon = NSEntityDescription.insertNewObject(forEntityName: "Beacon", into: context) as! Beacon
//                newBeacon.id = b.id
//                newBeacon.resident_id = b.resident_id
//                newBeacon.major = Int32(b.major.hashValue)
//                newBeacon.minor = Int32(b.minor.hashValue)
//                newBeacon.uuid = b.uuid
//                newBeacon.status = b.status
//                newBeacon.name = b.name
//                
//            }
//            
//        }
        
    }
    
    func clearLocal() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            do {
                
                let entityNames = ["Beacon"]
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.delete(object)
                    }
                    
                }
                
                try(context.save())
                
            } catch let err {
                print(err)
            }
            
        }
    }

    
    // Manage Collection View

    
    var updateTimer: Timer?
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    
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
    
    
    
    
}

