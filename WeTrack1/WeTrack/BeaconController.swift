//
//  BeaconController.swift
//  WeTrack
//
//  Created by xuhelios on 1/19/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

import CoreLocation
import Alamofire
import RealmSwift

let realm = try! Realm()

class BeaconController: UICollectionViewController, UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate  {
    
    var beacons : [Beacon]?
    
    fileprivate let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.beacons = GlobalData.history
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView!.reloadData()
        
        
    }

    
    // send information of 2 classmates you detected to server
    // if it sends successfully, you will take attendance successfully
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupData()
        self.beacons = GlobalData.history
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        setUp()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        navigationItem.title = "Beacon Detecting"
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(BeaconCell.self, forCellWithReuseIdentifier: cellId)
        
        NotificationCenter.default.addObserver(self,selector: #selector(load), name: NSNotification.Name(rawValue: "updateHistory"), object: nil)
        
               
        let newClearButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BeaconController.clearAll(sender:)))
        
        self.navigationItem.rightBarButtonItem = newClearButton
//        let LogoutBTN = UIBarButtonItem(title: "LogOut", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BeaconController.logOut(sender:)))
//        
//        self.navigationItem.leftBarButtonItem = LogoutBTN
    }
    
//    func logOut(sender: UIBarButtonItem) {
//        // Perform your custom actions
//        // ...
//        GlobalData.history.removeAll()
//        clearLocal()
//        // Go back to the previous ViewController
//        let vc = storyboard?.instantiateViewController(withIdentifier: "setting") as! ViewController
//        present(vc, animated: true, completion: nil)
//        
//        
//        
//    }
    
    func clearAll(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        GlobalData.history.removeAll()
        self.beacons = GlobalData.history
        self.collectionView?.reloadData()
        // Go back to the previous ViewController
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    func load(){
        self.beacons = GlobalData.history
        self.collectionView!.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = beacons?.count {
            
            return count
            
        }
  
        return 2
    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BeaconCell
////        if let beacon = beacons?[indexPath.item] {
////            cell.beacon = beacon
////        }
//        let cell = BeaconCell()
//        return cell
//        
//    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BeaconCell
        
        // Configure the cell
        if let beacon = beacons?[indexPath.item] {
            cell.beacon = beacon
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "detailSegue2", sender: nil)
      
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let indexPath = getIndexPathForSelectedCell() {
          //  print ("index  \(indexPath.item)")
            let y = (beacons?[indexPath.item])! as Beacon
            
            let x = GlobalData.residentList.first(where: {$0.id == y.resident_id})
            
            let detailViewController = segue.destination as! Detail
            detailViewController.resident = x!
        }
    }
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        
        var indexPath:IndexPath?
        
        if (collectionView?.indexPathsForSelectedItems!.count)! > 0 {
            indexPath = collectionView?.indexPathsForSelectedItems![0]
        }
        return indexPath
    }

    
    var locationManager : CLLocationManager!
    
    //    var beaconList = [Beacon]()
    //    var currentRegionList = [CLBeaconRegion]()
    var newRegionList = [CLBeaconRegion]()
    var residentList = [Resident]()
    
    
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
        
        
        Alamofire.request(Constant.URLmissing, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            let statusCode = response.response?.statusCode
            print("connection code \(statusCode)")
            if (statusCode == 200){
                
                self.newRegionList = [CLBeaconRegion]()
                self.residentList = [Resident]()
                GlobalData.beaconList = [Beacon]()
             
                if let JSONS = response.result.value as? [[String: Any]] {
                    
                    for json in JSONS {
                        
                        let newResident = Resident()
                        
                        newResident.status = (json["status"] as? Bool)!
                        
                        if ((newResident.status.hashValue != 0)){
                            
                            newResident.name = (json["fullname"] as? String)!
                            newResident.id = (json["id"] as? Int32)!
                            newResident.photo = (json["image_path"] as? String)!
                            newResident.remark = (json["remark"] as? String)!
                            
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
                                    newBeacon.photopath = (json["image_path"] as? String)!
                                    if (newBeacon.status.hashValue != 0){
                                        
                                        newBeacon.name = newResident.name + "#" + String(newBeacon.id) + "#" + String(newResident.id)
                                        print("** NAME \(newBeacon.name)")
                                        let uuid = NSUUID(uuidString: newBeacon.uuid) as! UUID
                                        let newRegion = CLBeaconRegion(proximityUUID: uuid, major: UInt16(newBeacon.major) as CLBeaconMajorValue, minor: UInt16(newBeacon.minor) as CLBeaconMajorValue, identifier: newBeacon.name )
                                        print("mornitor \(newBeacon.name)")
                                        self.newRegionList.append(newRegion)
                                        
                                        GlobalData.beaconList.append(newBeacon)
                                       // GlobalData.findB.updateValue(newBeacon, forKey: newBeacon.id.description)
                                        
                                    }
                                }
                            }
                            if let location = json["locations"] as? [[String: Any]] {
                                if (location.count>0){
                                    newResident.seen = (location[0]["created_at"] as! String)
                                }
                            }
                            self.residentList.append(newResident)
                           
                        }
                    }
                }
                print("finish load")
                
                //self.collectionView?.reloadData()
                
                
                
                
                var notification = UILocalNotification()
                notification.alertBody = "Load new list"
                notification.soundName = "Default"
                UIApplication.shared.presentLocalNotificationNow(notification)
                
                self.switchMornitoringList()
                self.saveCurrentListLocal()
                
            }else{
                // when connecting internet is fail, the app uses the lastest local data to run
                // the new data will be update for both app and local data
                
               // self.loadLocal()
                //print("beaconlistwhen loadlocal \(GlobalData.beaconList.count)")
                
                
            }// if status
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "syncServer"), object: nil)
            
        }
        
        
    }
    
    
    func loadLocal(){
        
        
        GlobalData.beaconList = Array(realm.objects(Beacon.self))
        GlobalData.residentList = Array(realm.objects(Resident.self))
        
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        
//        if let context = delegate?.persistentContainer.viewContext {
//            
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Beacon")
//            request.returnsObjectsAsFaults = false
//            
//            do {
//                GlobalData.beaconList = try! context.fetch(request) as! [Beacon]
//                
//                for newBeacon in GlobalData.beaconList{
//                    
//                    let uuid = NSUUID(uuidString: newBeacon.uuid) as! UUID
//                    let newRegion = CLBeaconRegion(proximityUUID: uuid, major: UInt16(newBeacon.major) as CLBeaconMajorValue, minor: UInt16(newBeacon.minor) as CLBeaconMajorValue, identifier: newBeacon.name )
//                    print("mornitor \(newBeacon.name)")
//                    
//                    GlobalData.currentRegionList.append(newRegion)
//                //    GlobalData.findB = [String: Beacon]()
//              
//                    
//                    let info = newBeacon.name.components(separatedBy: "#")
//                    
//                  //  GlobalData.findB.updateValue(newBeacon, forKey: info[1])
//                    
//                    //let x = GlobalData.findR[info[2]]! as Residentx
//                    let newResident = Resident()
//                    newResident.name = info[0]
//                    newResident.id = Int32(info[2])!
//                    newResident.photo = newBeacon.photopath
//                    GlobalData.residentList.append(newResident)
//                
//                }
//                
//            }catch{
//                fatalError("Failed to fetch \(error)")
//            }
//            
//            //subjects = subjects?.sorted(by: {$0.name!.compare($1.name! as String) == .orderedAscending})
//        }
        
    }
    
    func saveCurrentListLocal(){
        
        if (GlobalData.currentRegionList.count == 0 || GlobalData.beaconList.count == 0){
            return
        }
        
      //  clearLocal()
        try! realm.write {
            
            let bc = Array(realm.objects(Beacon.self))
            GlobalData.residentList = Array(realm.objects(Resident.self))
            realm.delete(GlobalData.residentList)
            realm.delete(bc)
            GlobalData.residentList = self.residentList
            
            realm.add(GlobalData.residentList)
            realm.add(GlobalData.beaconList)
        }
      /*  try! realm.write {
            realm.add(GlobalData.beaconList)
            realm.add(GlobalData.residentList)
        }
        */
        
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        
//        if let context = delegate?.persistentContainer.viewContext {
//            
//            for b in GlobalData.beaconList {
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
//            
//        }
        
    }
    
    func clearLocal() {
     
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        
//        if let context = delegate?.persistentContainer.viewContext {
//            
//            do {
//                
//                let entityNames = ["Beacon"]
//                
//                for entityName in entityNames {
//                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//                    
//                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
//                    
//                    for object in objects! {
//                        context.delete(object)
//                    }
//                    
//                }
//                
//                try(context.save())
//                
//            } catch let err {
//                print(err)
//            }
//            
//        }
    }
    
    
    var updateTimer: Timer?
    
   /* func appDidEnterBackground(notification:NSNotification) {
        updateTimer?.invalidate()
        updateTimer = nil
        if backgroundTask != UIBackgroundTaskInvalid {
            endBackgroundTask()
        }
    }*/

    
  /* var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
 
    func endBackgroundTask() {
                print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
     */
    
//    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion){
//        
//        print("@3: -____- state \(region.identifier)" )
//        switch state {
//        case .inside:
//            print(" -____- Inside \(region.identifier)");
//            
//            self.beacons = GlobalData.history
//            self.collectionView!.reloadData()
//            
//        //report(region: CLRegion)
//        case .outside:
//            print(" -____- Outside");
//             
//        case .unknown:
//            print(" -____- Unknown");
//        default:
//            print(" -____-  default");
//        }
//    }
//    
//    
//    
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        
//        // print("@1: did exit region!!!")
//        
//        self.beacons = GlobalData.history
//        self.collectionView!.reloadData()
//    }
    
}
class BeaconCell: BaseCell {
    
    //    let profileImageView: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.contentMode = .scaleAspectFill
    //        imageView.layer.cornerRadius = 34
    //        imageView.layer.masksToBounds = true
    //        return imageView
    //    }()
    
    var beacon: Beacon?{
        didSet {
            
            time.text = beacon?.seen.description
            
            beaconName.text = beacon?.name
            
            if (beacon?.detect == false){
     
                    statusImage.image = UIImage(named: "exit")
            }else{
                statusImage.image = UIImage(named: "enter2")
            }
            
            if (beacon?.photopath == ""){
                residentPhoto.image = UIImage(named: "default_avatar")
            }else{
                let url = NSURL(string: Constant.photoURL + (beacon?.photopath)!)
                
                //print("Urlimage \(url)")
                
                let data = NSData(contentsOf: url as! URL)
                if data != nil {
                    residentPhoto.image = UIImage(data:data! as Data)
                }
            }

        }
    }
    
    let residentPhoto : UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(named: "yoo2")
        
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    let beaconName : UILabel = {
        let label = UILabel()
        label.text = "Xu Helios"
        label.textColor = UIColor(red:0.10, green:0.31, blue:0.17, alpha:1.0)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let time : UILabel = {
        let label = UILabel()
        label.text = "00 : 00"
        label.font = UIFont.italicSystemFont(ofSize: 14)
        return label
    }()
    

    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.00, green:0.36, blue:0.16, alpha:0.5)
        // view.backgroundColor = UIColor(red:0, green:0.92, blue:0.41, alpha:0.5)
        return view
    }()
    
    let statusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "enter2")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        
        addSubview(residentPhoto)
        addSubview(dividerLineView)
        
        setupContainerView()
        
        //   statusImage.image = UIImage(named: "dol")
        
        addConstraintsWithFormat("H:|-12-[v0(69)]", views: residentPhoto)
        addConstraintsWithFormat("V:[v0(69)]", views: residentPhoto)
        
        addConstraint(NSLayoutConstraint(item: residentPhoto, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat("H:|-82-[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(1)]|", views: dividerLineView)
    }
    
    fileprivate func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        
        addConstraintsWithFormat("H:|-100-[v0]|", views: containerView)
        addConstraintsWithFormat("V:[v0(69)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(time)
        containerView.addSubview(beaconName)
        containerView.addSubview(statusImage)
        
        containerView.addConstraintsWithFormat("H:|[v0]", views: beaconName)
        
        containerView.addConstraintsWithFormat("V:|[v0(35)][v1(34)]|", views: beaconName, time)
        
        containerView.addConstraintsWithFormat("H:|[v0]-8-[v1(25)]-12-|", views: time, statusImage)
        
        containerView.addConstraintsWithFormat("V:[v0(25)]|", views: statusImage)
    }
    
    
}
