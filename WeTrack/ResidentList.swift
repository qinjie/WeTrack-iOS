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

class ResidentList: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
 
    var residents : [Resident]?
    
    fileprivate let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.residents = GlobalData.residentList
        self.collectionView!.reloadData()
        
    }

    func loadFirstTime(){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constant.token
            // "Accept": "application/json"
        ]
        
        Alamofire.request(Constant.URLmissing, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            let statusCode = response.response?.statusCode
            print("connection code \(statusCode)")
            if (statusCode == 200){
                
                GlobalData.beaconList = [Beacon]()
                GlobalData.residentList = [Resident]()
                
                
                if let JSONS = response.result.value as? [[String: Any]] {
                    
                    for json in JSONS {
                        
                        let newResident = Resident()
                        
                        newResident.status = (json["status"] as? Bool)!
                        
                        if ((newResident.status.hashValue != 0)){
                            
                            newResident.name = (json["fullname"] as? String)!
                            newResident.id = (json["id"] as? Int32)!
                            newResident.photo = (json["image_path"] as? String)!
                            newResident.remark = (json["remark"] as? String)!
                            newResident.nric = (json["nric"] as? String)!
                            newResident.report = (json["reported_at"] as? String)!
                            newResident.dob = (json["dob"] as? String)!
                            
                            if let location = json["locations"] as? [[String: Any]]{
                                if (location.count > 0){
                                    newResident.address = location[0]["address"] as! String
                                    newResident.lat = location[0]["latitude"] as! String
                                    newResident.long = location[0]["longitude"] as! String
                                    print("add \(newResident.address)")
                                }
                            }
                            
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
                                        
                                        GlobalData.currentRegionList.append(newRegion)
                                        GlobalData.beaconList.append(newBeacon)
                                        
                                    }
                                }
                            }
                            
                            if let location = json["locations"] as? [[String: Any]] {
                                if (location.count>0){
                                    newResident.seen = (location[0]["created_at"] as! String)
                                }
                            }
                            
                            GlobalData.residentList.append(newResident)
                            
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
                
                self.loadLocal()
                print("beaconlistwhen loadlocal \(GlobalData.beaconList.count)")
                
            }// if status
            
            self.residents = GlobalData.residentList
            self.collectionView!.reloadData()
            self.start()
        }
    }
    
    let locationManager = CLLocationManager()
    func start(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "start"), object: nil)
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if (GlobalData.currentRegionList.count > 0 && GlobalData.currentRegionList.count < 20 ){
            for uniqueRegion in GlobalData.currentRegionList{
                
                locationManager.startMonitoring(for: uniqueRegion)
            }
        }
        

    }
 
    func loadLocal(){
        
        GlobalData.beaconList = Array(realm.objects(Beacon.self))
        GlobalData.residentList = Array(realm.objects(Resident.self))
    }
    
    func saveCurrentListLocal(){
        if (GlobalData.currentRegionList.count == 0 || GlobalData.beaconList.count == 0){
            return
        }
        
        //  clearLocal()
        try! realm.write {
            
            let bc = Array(realm.objects(Beacon.self))
            let rl = Array(realm.objects(Resident.self))
            realm.delete(rl)
            realm.delete(bc)
            
            realm.add(GlobalData.residentList)
            realm.add(GlobalData.beaconList)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // for Collection View
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        navigationItem.title = "Missing Resident"
  
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(ResidentCell.self, forCellWithReuseIdentifier: cellId)
        
        
        //setupData()
        loadFirstTime()
       
        
         NotificationCenter.default.addObserver(self,selector: #selector(sync), name: NSNotification.Name(rawValue: "updateHistory"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(sync), name: NSNotification.Name(rawValue: "syncServer"), object: nil)
        
    }
    
    func sync(){
        self.residents = GlobalData.residentList
        self.collectionView!.reloadData()
        let today = Date()
        print("now1 \(today)")
    
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = residents?.count {
            
            return count
            
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ResidentCell
        if let resident = residents?[indexPath.item] {
            cell.resident = resident
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
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
    //    self.performSegue(withIdentifier: "detailSegue", sender: nil)
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard?.instantiateViewController(withIdentifier: "Detail") as! Detail
//                   self.navigationController?.pushViewController(controller, animated: true)
//                } else {
//                    NSLog("Nil cmnr")
//                }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
            if let indexPath = getIndexPathForSelectedCell() {
                
                let x = residents?[indexPath.item]
                
                let detailViewController = segue.destination as! DetailController
                detailViewController.res = x!
            }
    
    
    }
    
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        
        var indexPath:IndexPath?
        
        if (collectionView?.indexPathsForSelectedItems!.count)! > 0 {
            indexPath = collectionView?.indexPathsForSelectedItems![0]
        }
        return indexPath
    }

    
}
class ResidentCell: BaseCell {
    
    //    let profileImageView: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.contentMode = .scaleAspectFill
    //        imageView.layer.cornerRadius = 34
    //        imageView.layer.masksToBounds = true
    //        return imageView
    //    }()
    
    var resident: Resident?{
        didSet {
            
            residentName.text = resident?.name
            idLabel.text = resident?.id.description
            //let url = Constant.photoURL + (resident?.photo)!
            
            if (resident?.photo == ""){
                residentPhoto.image = UIImage(named: "default_avatar")
            }else{
                let url = NSURL(string: Constant.photoURL + (resident?.photo)!)
                
                //print("Urlimage \(url)")
                
                let data = NSData(contentsOf: url as! URL)
                if data != nil {
                    residentPhoto.image = UIImage(data:data! as Data)
                }
            }
            lastseen.text = resident?.seen
        
            
        }
    }
    
    let residentPhoto: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(named: "yoo2")
        
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView

    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.text = "0000"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.00, green:0.36, blue:0.16, alpha:0.5)
        // view.backgroundColor = UIColor(red:0, green:0.92, blue:0.41, alpha:0.5)
        return view
    }()
    
    let residentName: UILabel = {
        let label = UILabel()
        label.text = "Xu Helios"
        label.textColor = UIColor(red:0.10, green:0.31, blue:0.17, alpha:1.0)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let lastseen: UILabel = {
        let label = UILabel()
        label.text = "......"
        label.textColor = UIColor(red:0.10, green:0.31, blue:0.17, alpha:1.0)
        //  label.backgroundColor = UIColor(red:0.51, green:0.83, blue:0.93, alpha:0.5)
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    let statusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
        
   
        containerView.addSubview(residentName)
        containerView.addSubview(lastseen)
        containerView.addSubview(statusImage)
        
        containerView.addConstraintsWithFormat("V:|[v0(35)][v1(34)]|", views: residentName, lastseen)
        
        containerView.addConstraintsWithFormat("H:|[v0]-8-[v1(40)]-12-|", views: residentName, statusImage)
        
        containerView.addConstraintsWithFormat("H:|[v0]-8-[v1(40)]-12-|", views: lastseen, statusImage)
        
        containerView.addConstraintsWithFormat("V:[v0(20)]|", views: statusImage)
    }
    
    
}



extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    }
}

