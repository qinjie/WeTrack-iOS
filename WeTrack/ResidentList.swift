 //
//  FViewCellCollection.swift
//  WeTrack
//
//  Created by xuhelios on 1/19/17.
//  Copyright © 2017 beacon. All rights reserved.
//
//
//
//  Today2ViewController.swift
//  ATKdemo
//
//  Created by xuhelios on 12/9/16.
//  Copyright © 2016 xuhelios. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
 import SwiftyJSON

class ResidentList: BaseViewController, CLLocationManagerDelegate {
    @IBOutlet weak var tbl : UITableView!
    var residents : [Resident]?
    fileprivate let cellId = "ResidentTableViewCell"
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tbl.estimatedRowHeight = 100
        tbl.rowHeight = UITableViewAutomaticDimension
        tbl.separatorColor = UIColor.seperatorApp
        tbl.tableFooterView = UIView.init(frame: CGRect.zero)
        
        
        // for Collection View
        
        //collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        navigationItem.title = "Missing Residents"
        self.refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.mainApp
        self.refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tbl.addSubview(refreshControl)
        
//        collectionView?.backgroundColor = UIColor.white
//        collectionView?.alwaysBounceVertical = true
//        
//        collectionView?.register(ResidentCell.self, forCellWithReuseIdentifier: cellId)
        
        Constant.username = UserDefaults.standard.string(forKey: "username")!
        Constant.user_id = UserDefaults.standard.integer(forKey: "userid")
        Constant.role = UserDefaults.standard.integer(forKey: "role")
       
        
        if (Constant.role != 5 && Constant.isLogin == false){
            
            var localdata = "allresident.txt"
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                var filePath = dir.appendingPathComponent(localdata)
                
                // read from file
                if let dict = NSKeyedUnarchiver.unarchiveObject(withFile: filePath.path) as? [Resident]{
                
                    GlobalData.allResidents = dict
                
                 print(" all re2 \(GlobalData.allResidents.count)")
                
                }
                
                localdata = "relative.txt"
                
                filePath = dir.appendingPathComponent(localdata)
                
                if let dict = NSKeyedUnarchiver.unarchiveObject(withFile: filePath.path) as? [Resident]{
                    
                    GlobalData.relativeList = dict
                    
                    print(" all relate \(GlobalData.relativeList.count)")
                    
                }

                for r in GlobalData.allResidents{
                    if (GlobalData.relativeList.contains(where: {$0.id == r.id})){
                        print(" id relate \(r.id)")
                        r.isRelative = true
                    }
                }
            }
            
        }
        
        loadServerList()
        start()
        setUp()
        //setupData()
        
        
        
        
    }
    
    func reloadData() {
        loadServerList()
    }
    
    @IBAction func sync(_ sender: Any) {
    
        loadServerList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.residents = GlobalData.missingList
//        self.collectionView!.reloadData()
        
       print(" all re \(GlobalData.allResidents.count)")
       print(" all mis \(GlobalData.missingList.count)")
    }
    
    
    func setUp(){
        
        newRegionList = GlobalData.currentRegionList
        switchMornitoringList()
        self.saveCurrentListLocal()
        self.updateTimer = Timer.scheduledTimer(timeInterval: Constant.restartTime, target: self, selector: #selector(self.loadServerList), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self,selector: #selector(start), name: NSNotification.Name(rawValue: "enableScanning"), object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(stop), name: NSNotification.Name(rawValue: "disableScanning"), object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(forLogout), name: NSNotification.Name(rawValue: "logout"), object: nil)
        
    }
    
    func forLogout(){
        self.updateTimer?.invalidate()
    }

    func loadServerList(){
        print(" token \(Constant.token)")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constant.token
            // "Accept": "application/json"
        ]
        
        var JSONS : [[String: Any]]!
        self.newRegionList = [CLBeaconRegion]()
        GlobalData.beaconList = [Beacon]()
        GlobalData.missingList = [Resident]()
        Alamofire.request(Constant.URLmissing, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print("check2")
            NSLog("Ahihi \(response)")
            let json = JSON.init(data: response.data!)
            NSLog("Ahihi \(json)")
            let statusCode = response.response?.statusCode
            self.refreshControl.endRefreshing()
            print("connection code \(statusCode)")
            if (statusCode == 200){
                
                self.refreshControl.endRefreshing()
                
                if let newdata = response.result.value as? [[String: Any]] {
                    
                    JSONS = newdata
                    
                    let localdata = "localdata.json" //this is the file. we will write to and read from it
                    
                    
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        
                        let filePath = dir.appendingPathComponent(localdata)
                        
                        // write to file
                        NSKeyedArchiver.archiveRootObject(newdata, toFile: filePath.path)
                        
                        
                    }
                }
                print("finish load")
                
                
                
                
            }else{
                
                let localdata = "localdata.json"
                
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    
                    let filePath = dir.appendingPathComponent(localdata)
                    
                    // read from file
                    JSONS = NSKeyedUnarchiver.unarchiveObject(withFile: filePath.path) as! [[String: Any]]
                    
                    
                    print("testlocaldict2 \(JSONS)")
                    
                    
                }
             //   print("beaconlistwhen loadlocal \(GlobalData.beaconList.count)")
                
            }// if status
            
            
            
            for json in JSONS {
                NSLog("Test demo", json)
                let status = (json["status"] as? Bool)!
                
                if ((status.hashValue != 0)){
                    
                    let rid = String((json["id"] as? Int)!)
                    
                    var r  = Resident()
                    
                    if let newMissing = GlobalData.allResidents.first(where: {$0.id == rid}){
                        // error here
                      
                            newMissing.status = true
                            
                            newMissing.report = (json["reported_at"] as? String)!
                    
                        r = newMissing
                        
                    }else{
                        
                        let newMissing = Resident()
                        
                        newMissing.status = true
                        
                        newMissing.name = (json["fullname"] as? String)!
                        newMissing.id = String((json["id"] as? Int)!)
                        newMissing.photo = (json["image_path"] as? String)!
                        newMissing.remark = (json["remark"] as? String)!
                        newMissing.report = (json["reported_at"] as? String)!
                        newMissing.nric = (json["nric"] as? String)!
                        newMissing.dob = (json["dob"] as? String)!
                        newMissing.report = (json["reported_at"] as? String)!
                        
                        r = newMissing
                    }
                    
                    if let beacon = json["beacons"] as? [[String: Any]] {
                        var tmpBeacon = [Beacon]()
                        for b in beacon{
                            
                            let newBeacon = Beacon()
                            newBeacon.uuid = (b["uuid"] as? String)!
                            newBeacon.major = (b["major"] as? Int32)!
                            newBeacon.minor = (b["minor"] as? Int32)!
                            newBeacon.id = (b["id"] as? Int)!
                            print("\(newBeacon.id)")
                            newBeacon.resident_id = Int(r.id)!
                            newBeacon.status = (b["status"] as? Bool)!
                            
                            if (newBeacon.status.hashValue != 0){
                                
                                newBeacon.name = (r.name) + "#" + String(newBeacon.id) + "#" + String(r.id)
                                print("** NAME \(newBeacon.name)")
                                let uuid = NSUUID(uuidString: newBeacon.uuid) as! UUID
                                let newRegion = CLBeaconRegion(proximityUUID: uuid, major: UInt16(newBeacon.major) as CLBeaconMajorValue, minor: UInt16(newBeacon.minor) as CLBeaconMinorValue, identifier: newBeacon.name )
                                print("mornitor \(newBeacon.name)")
                           
            
                                self.newRegionList.append(newRegion)
                                GlobalData.beaconList.append(newBeacon)
                                
                            }
                            tmpBeacon.append(newBeacon)
                        }
                        r.beacons = tmpBeacon
                    }
                    
                    
                    GlobalData.missingList.append(r)
                    
                }
                
            }
            GlobalData.relativeList = GlobalData.allResidents.filter({$0.isRelative == true})
            
//            var notification = UILocalNotification()
//            notification.alertBody = "Load new list"
//            notification.soundName = "Default"
//            UIApplication.shared.presentLocalNotificationNow(notification)
            
            self.switchMornitoringList()
            
            self.residents = GlobalData.missingList
            self.tbl.reloadData()
            
            
            GlobalData.nearMe.removeAll()
        }
    }
    
    let locationManager = CLLocationManager()
    
    func start(){
        
        if (Constant.isScanning == false){
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "start"), object: nil)
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if (GlobalData.currentRegionList.count <= 20){
            
            for uniqueRegion in GlobalData.currentRegionList{
                
                self.locationManager.startMonitoring(for: uniqueRegion)
            }
        }else{
            // group beacon
        }

    }
    
    func stop(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stop"), object: nil)
        
        for uniqueRegion in GlobalData.currentRegionList{
            
            self.locationManager.stopMonitoring(for: uniqueRegion)
        }
   
    }
    
    
 
    func loadLocal(){
        
        
    }
    
    func saveCurrentListLocal(){
//        if (GlobalData.currentRegionList.count == 0 || GlobalData.beaconList.count == 0){
//            return
//        }
//        
//        //  clearLocal()
//        try! realm.write {
//            
//            realm.deleteAll()
//            
//            print("count \(GlobalData.allResidents.count)")
//            realm.add(GlobalData.allResidents)
//            realm.add(GlobalData.beaconList)
//        }

    }
    
    var updateTimer: Timer?
    
    
    func switchMornitoringList(){
        
        if (self.n > 1){
            
            for uniqueRegion in GlobalData.currentRegionList{
                
                self.locationManager.stopMonitoring(for: uniqueRegion)
            }
            
        }
        
        if (newRegionList.count > 0){
            
            GlobalData.currentRegionList = newRegionList
            
            start()
            
        }
        self.n = newRegionList.count
        
    }

    
    var newRegionList = [CLBeaconRegion]()
    var residentList = [Resident]()
    
    
    var n = 0
    
    func sync(){
        self.residents = GlobalData.missingList
        self.tbl.reloadData()
        let today = Date()
        print("now1 \(today)")
    
    }

    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let count = residents?.count {
//            
//            return count
//            
//        }
//        return 0
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ResidentCell
//        if let resident = residents?[indexPath.item] {
//            cell.resident = resident
//        }
//        return cell
//        
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 100)
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//  
//    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //self.performSegue(withIdentifier: "detailSegue", sender: nil)
//    //    self.performSegue(withIdentifier: "detailSegue", sender: nil)
////        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
////        let controller = storyboard?.instantiateViewController(withIdentifier: "Detail") as! Detail
////                   self.navigationController?.pushViewController(controller, animated: true)
////                } else {
////                    NSLog("Nil cmnr")
////                }

    //}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
            if let indexPath = getIndexPathForSelectedCell() {
                
                let x = residents?[indexPath.item]
                
                let detailPage = segue.destination as! ResidentDetailPage
                detailPage.resident = x!
            }
    
    
    }
    
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        
        var indexPath:IndexPath?
        
        if (self.tbl.indexPathForSelectedRow != nil) {
            return (self.tbl.indexPathForSelectedRow)
        }
        
        return nil
    }

    
}
 extension ResidentList : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residents?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ResidentTableViewCell
        let type = (self.residents?[indexPath.row].beacons?.count)! > 0 ? false : true
        cell.setDate(resident: (self.residents?[indexPath.row])!, warning: type)
//        cell.setData(resident: (residents?[indexPath.row])!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
 }







