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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for Collection View
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        navigationItem.title = "Missing Residents"
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(ResidentCell.self, forCellWithReuseIdentifier: cellId)
        
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
    
    @IBAction func sync(_ sender: Any) {
    
        loadServerList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.residents = GlobalData.missingList
        self.collectionView!.reloadData()
        
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
            let statusCode = response.response?.statusCode
            print("connection code \(statusCode)")
            if (statusCode == 200){
                
                
                
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
                        }
                    }
                    
                    
                    GlobalData.missingList.append(r)
                    
                }
                
            }
            GlobalData.relativeList = GlobalData.allResidents.filter({$0.isRelative == true})
            
            var notification = UILocalNotification()
            notification.alertBody = "Load new list"
            notification.soundName = "Default"
            UIApplication.shared.presentLocalNotificationNow(notification)
            
            self.switchMornitoringList()
            
            self.residents = GlobalData.missingList
            self.collectionView!.reloadData()
            
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
                
                let detailPage = segue.destination as! ResidentDetailPage
                detailPage.resident = x!
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
            lastseen.text = resident?.report
            if (lastseen.text == ""){
                lastseen.text = "not report yet"
            }
            
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

