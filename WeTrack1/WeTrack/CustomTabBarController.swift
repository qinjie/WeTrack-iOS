//
//  CustomTabBarController.swift
//  WeTrack
//
//  Created by xuhelios on 1/19/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import CoreData


class CustomTabBarController: UITabBarController, CLLocationManagerDelegate {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let residentList = ResidentList(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: residentList)
        navigationController.title = "Active Resident"
        navigationController.tabBarItem.image = UIImage(named: "resident")
        
        let beaconController = BeaconController(collectionViewLayout: UICollectionViewFlowLayout())
        let secondNavigationController = UINavigationController(rootViewController: beaconController)
        secondNavigationController.title = "Beacon Detecting"
        secondNavigationController.tabBarItem.image = UIImage(named: "geo")
        
//        let messengerVC = UIViewController()
//        let messengerNavigationController = UINavigationController(rootViewController: messengerVC)
//        messengerNavigationController.title = "Messenger"
//        messengerNavigationController.tabBarItem.image = UIImage(named: "messenger_icon")
//        
//        let notificationsNavController = UINavigationController(rootViewController: UIViewController())
//        notificationsNavController.title = "Notifications"
//        notificationsNavController.tabBarItem.image = UIImage(named: "globe_icon")
//        
//        let moreNavController = UINavigationController(rootViewController: UIViewController())
//        moreNavController.title = "More"
//        moreNavController.tabBarItem.image = UIImage(named: "more_icon")
//        
//        viewControllers = [navigationController, secondNavigationController, messengerNavigationController, notificationsNavController, moreNavController]
        
       
        viewControllers = [navigationController, secondNavigationController]
        
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor(red:0.90, green:0.91, blue:0.92, alpha:1.0).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        
        let selectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        
        tabBar.unselectedItemTintColor = unselectedColor
            
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
   
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
        
        
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        setUp()
        
    }
    
    fileprivate func createDummyNavControllerWithTitle(_ title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }

    var locationManager : CLLocationManager!

    //    var beaconList = [Beaconx]()
    //    var currentRegionList = [CLBeaconRegion]()
    var newRegionList = [CLBeaconRegion]()
    var residentList = [Residentx]()
    
    
    var n = 0
    
    func setUp(){
        
        newRegionList = GlobalData.currentRegionList
        switchMornitoringList()
        
        self.updateTimer = Timer.scheduledTimer(timeInterval: Constant.restartTime, target: self, selector: #selector(self.loadServerList), userInfo: nil, repeats: true)
        
        
    }
    
    
    func switchMornitoringList(){
        
        if (self.n > 1){
            
            for uniqueRegion in GlobalData.currentRegionList{
                
                self.locationManager.stopMonitoring(for: uniqueRegion)
            }
            
        }
        
        if (newRegionList.count > 0){
            
            GlobalData.currentRegionList = newRegionList
            
            if (GlobalData.currentRegionList.count <= 20){
                
                for uniqueRegion in GlobalData.currentRegionList{
                    
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
        GlobalData.beaconList = [Beaconx]()
        
        
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
                            newResident.photo = (json["image_path"] as? String)!
                            
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
                                    newBeacon.photopath = (json["image_path"] as? String)!
                                    if (newBeacon.status.hashValue != 0){
                                        
                                        newBeacon.name = newResident.name + "#" + String(newBeacon.id) + "#" + String(newResident.id)
                                        print("** NAME \(newBeacon.name)")
                                        let uuid = NSUUID(uuidString: newBeacon.uuid) as! UUID
                                        let newRegion = CLBeaconRegion(proximityUUID: uuid, major: UInt16(newBeacon.major) as CLBeaconMajorValue, minor: UInt16(newBeacon.minor) as CLBeaconMajorValue, identifier: newBeacon.name )
                                        print("mornitor \(newBeacon.name)")
                                        self.newRegionList.append(newRegion)
                                        
                                        GlobalData.beaconList.append(newBeacon)
                                        GlobalData.findB.updateValue(newBeacon, forKey: newBeacon.id.description)
                                        
                                    }
                                }
                            }
                            
                            self.residentList.append(newResident)
                            GlobalData.findR.updateValue(newResident, forKey: newResident.id.description)
                        }
                    }
                }
                print("finish load")
                
                //self.collectionView?.reloadData()
                
                GlobalData.residentList = self.residentList
                
                
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
                print("beaconlistwhen loadlocal \(GlobalData.beaconList.count)")
                
                
            }// if status
          
        }
        
        
    }
    
    
    func loadLocal(){
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Beacon")
            request.returnsObjectsAsFaults = false
            
            do {
                GlobalData.beaconList = try! context.fetch(request) as! [Beaconx]
                
                for newBeacon in GlobalData.beaconList{
                    
                    let uuid = NSUUID(uuidString: newBeacon.uuid) as! UUID
                    let newRegion = CLBeaconRegion(proximityUUID: uuid, major: UInt16(newBeacon.major) as CLBeaconMajorValue, minor: UInt16(newBeacon.minor) as CLBeaconMajorValue, identifier: newBeacon.name )
                    print("mornitor \(newBeacon.name)")
                    
                    GlobalData.currentRegionList.append(newRegion)
                    GlobalData.findB = [String: Beaconx]()
                    GlobalData.findR = [String: Residentx]()
                    
                    let info = newBeacon.name.components(separatedBy: "#")
                    
                    GlobalData.findB.updateValue(newBeacon, forKey: info[1])
                    
                    //let x = GlobalData.findR[info[2]]! as Residentx
                    let newResident = Residentx()
                    newResident.name = info[0]
                    newResident.id = Int32(info[2])!
                    newResident.photo = newBeacon.photopath
                    GlobalData.residentList.append(newResident)
                    GlobalData.findR.updateValue(newResident, forKey: newResident.id.description)
                }
                
            }catch{
                fatalError("Failed to fetch \(error)")
            }
            
            //subjects = subjects?.sorted(by: {$0.name!.compare($1.name! as String) == .orderedAscending})
        }
        
    }
    
    func saveCurrentListLocal(){
        
        if (GlobalData.currentRegionList.count == 0 || GlobalData.beaconList.count == 0){
            return
        }
        
        clearLocal()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            for b in GlobalData.beaconList {
                
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

    
    
    
    
    // for important Data
    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
