//
//  ResidentControllerCollectionViewController.swift
//  WeTrack
//
//  Created by xuhelios on 1/18/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

import CoreData
import CoreLocation
import Alamofire

private let cellId = "Cell"

class ResidentController: UICollectionViewController, CLLocationManagerDelegate {


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var locationManager : CLLocationManager!
    
    var residentList = [Residentx]()
    var beaconList = [Beaconx]()
    var currentRegionList = [CLBeaconRegion]()
    var newRegionList = [CLBeaconRegion]()
    
    var region1 : CLBeaconRegion!
    var region2 : CLBeaconRegion!
    
    
    var n = 0
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        collectionView?.alwaysBounceVertical = true
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView?.register(ResidentCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.title = "Recent"
        
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
        residentList = [Residentx]()
        beaconList = [Beaconx]()
        
        
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
                            newResident.id = (json["id"] as? Int32)!
                            
                            if let beacon = json["beacons"] as? [[String: Any]] {
                                
                                for b in beacon{
                                    
                                    let newBeacon = Beaconx()
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
                self.collectionView?.reloadData()
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
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Beacon")
            request.returnsObjectsAsFaults = false
            
            do {
                beaconList = try! context.fetch(request) as! [Beaconx]
                
                for newBeacon in beaconList{
                    
                    let uuid = NSUUID(uuidString: newBeacon.uuid) as! UUID
                    let newRegion = CLBeaconRegion(proximityUUID: uuid, major: UInt16(newBeacon.major) as CLBeaconMajorValue, minor: UInt16(newBeacon.minor) as CLBeaconMajorValue, identifier: newBeacon.name )
                    print("mornitor \(newBeacon.name)")
                    self.newRegionList.append(newRegion)
                    self.beaconList.append(newBeacon)
                    
                }
                
            }catch{
                fatalError("Failed to fetch \(error)")
            }
            
            //subjects = subjects?.sorted(by: {$0.name!.compare($1.name! as String) == .orderedAscending})
        }
        
    }
    
    func saveCurrentListLocal(){
        
        if (currentRegionList.count == 0 || beaconList.count == 0){
            return
        }
        
        clearLocal()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            for b in beaconList {
                
                let newBeacon = NSEntityDescription.insertNewObject(forEntityName: "Beacon", into: context) as! Beacon
                newBeacon.id = b.id
                newBeacon.resident_id = b.resident_id
                newBeacon.major = Int32(b.major.hashValue)
                newBeacon.minor = Int32(b.minor.hashValue)
                newBeacon.uuid = b.uuid
                newBeacon.status = b.status
                newBeacon.name = b.name
                
            }
            
        }
        
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
    
    // MARK: UICollectionViewDataSource
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//
//        return 0
//    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("count2 \(residentList.count)")
        return 2
            //residentList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ResidentCell
        
        // Configure the cell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }

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






        
