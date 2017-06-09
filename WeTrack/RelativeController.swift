//
//  RelativeController.swift
//  WeTrack
//
//  Created by xuhelios on 2/22/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "Cell"

class RelativeController: BaseViewController {
    
    @IBOutlet weak var tbl : UITableView!
    
    var relatives : [Resident]?
    
    var refreshControl: UIRefreshControl!
    
    fileprivate let cellId = "ResidentTableViewCell"
    
    func loadRelativeList(){
        
        print("constant token \(Constant.token)")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constant.token
            // "Accept": "application/json"
        ]
        
        Alamofire.request(Constant.URLall, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            GlobalData.allResidents = [Resident]()
            
            if let JSON = response.result.value as? [[String: Any]] {
                
                for json in JSON {
                    let newResident = Resident()
                    
                    newResident.status = (json["status"] as? Bool)!
                    
                    newResident.name = (json["fullname"] as? String)!
                    newResident.id = String((json["id"] as? Int)!)
                    newResident.photo = (json["image_path"] as? String)!
                    newResident.remark = (json["remark"] as? String)!
                    newResident.nric = (json["nric"] as? String)!
                    newResident.dob = (json["dob"] as? String)!
                    
                    if let lastestLocation = json["latestLocation"] as? [[String: String]] {
                        if (lastestLocation.count > 0) {
                            let locationObj = Location(arr: lastestLocation[0])
                            newResident.lastestLocation = locationObj
                        }
                    }
                    
                    if let relatives = json["relatives"] as? [[String: Any]]{
                        
                        for relative in relatives{
                            
                            let x = relative["id"] as! Int
                            print("relative id \(x)")
                            if (x == Constant.user_id){
                                //   print("relative \(json["fullname"])")
                                newResident.isRelative = true
                                break
                            }
                        }
                    }
                    
                    if let beacons = json["beacons"] as? [[String : Any]] {
                        if (beacons.count > 0) {
                            newResident.beacon_count = beacons.count
                        }
                    }
                    
                    GlobalData.allResidents.append(newResident)
                }
                
            }
            
            GlobalData.relativeList = GlobalData.allResidents.filter({$0.isRelative == true})
            DispatchQueue.global().sync {
                self.tbl.reloadData()
                self.refreshControl.endRefreshing()
            }
            
            var file = "allresident.txt" //this is the file. we will write to and read from it
            
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                var filePath = dir.appendingPathComponent(file)
                
                // write to file
                NSKeyedArchiver.archiveRootObject(GlobalData.allResidents, toFile: filePath.path)
                
                file = "relative.txt"
                
                filePath = dir.appendingPathComponent(file)
                
                NSKeyedArchiver.archiveRootObject(GlobalData.relativeList, toFile: filePath.path)
            }
            
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.relatives = GlobalData.relativeList
//        self.collectionView!.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for Collection View
        
        tbl.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tbl.separatorColor = UIColor.seperatorApp
        tbl.tableFooterView = UIView.init(frame: CGRect.zero)
        tbl.estimatedRowHeight = 100
        tbl.rowHeight = UITableViewAutomaticDimension
        
        
        self.refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.mainApp
        self.refreshControl.addTarget(self, action: #selector(RelativeController.reloadData), for: .valueChanged)
        tbl.addSubview(refreshControl)
        
        navigationItem.title = "Your relatives"
        
        self.relatives = GlobalData.relativeList
        
        
        
    }
    
    func reloadData() {
        self.loadRelativeList()
        
    }
    
//
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let count = relatives?.count {
//            
//            return count
//            
//        }
//        return 1
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ResidentCell
//        if let relative = relatives?[indexPath.item] {
//            cell.resident = relative
//        }
//        return cell
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 100)
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    
//    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "detailSegue2", sender: nil)
//        //    self.performSegue(withIdentifier: "detailSegue", sender: nil)
//        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        //        let controller = storyboard?.instantiateViewController(withIdentifier: "Detail") as! Detail
//        //                   self.navigationController?.pushViewController(controller, animated: true)
//        //                } else {
//        //                    NSLog("Nil cmnr")
//        //                }
//        
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = getIndexPathForSelectedCell() {
            
            let x = relatives?[indexPath.item]
            
            let detailPage = segue.destination as! ResidentDetailPage
            detailPage.resident = x!
        }
        
    }
    
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        
        var indexPath:IndexPath?
        
        if (tbl.indexPathForSelectedRow != nil) {
            return (tbl.indexPathForSelectedRow)
        }
        
        return nil
    }
    
    
}

extension RelativeController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = relatives?.count {
            
            return count
            
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ResidentTableViewCell        
        cell.setData(resident: (relatives?[indexPath.row])!, type: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue2", sender: nil)
        tbl.deselectRow(at: indexPath, animated: true)
    }
}
