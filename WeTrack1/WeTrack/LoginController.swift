//
//  LoginController.swift
//  WeTrack
//
//  Created by xuhelios on 1/18/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import CoreLocation

class LoginController: UIViewController, CLLocationManagerDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearLocal()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func loginTapped(_ sender: Any) {
        
        //Wating dialog
        
        loadServerList()
            
        
        
        //for Location Manager
        
        
        
    }

    
    func loadServerList(){
        
        let alertController = UIAlertController(title: nil, message: "Please wait...\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
        

        
        let url = Constant.baseURL + "api/web/index.php/v1/resident?expand=beacons"
        
        GlobalData.residentList = [Residentx]()
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
                                            
                                            GlobalData.currentRegionList.append(newRegion)
                                            GlobalData.beaconList.append(newBeacon)
                                            GlobalData.findB.updateValue(newBeacon, forKey: newBeacon.id.description)
                                            
                                        }
                                    }
                                }
                                
                                GlobalData.residentList.append(newResident)
                                GlobalData.findR.updateValue(newResident, forKey: newResident.id.description)
                            }
                        }
                    }
                    print("finish load")
                    
                    var notification = UILocalNotification()
                    notification.alertBody = "Load new list"
                    notification.soundName = "Default"
                    UIApplication.shared.presentLocalNotificationNow(notification)
                    
                    self.saveCurrentListLocal()
                    
                }else{
                    // when connecting internet is fail, the app uses the lastest local data to run
                    // the new data will be update for both app and local data
                    
                    self.loadLocal()
                    print("beaconlistwhen loadlocal \(GlobalData.beaconList.count)")
        
                }// if status
            
                        DispatchQueue.main.async(execute: {
                //                        alertController.dismiss(animated: true, completion: nil)
            //   alertController.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)

//                }
            })
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
    
 
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
