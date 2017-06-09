//
//  NearMeController.swift
//  WeTrack
//
//  Created by xuhelios on 1/27/17.
//  Copyright © 2017 beacon. All rights reserved.
//
import CoreLocation
import UIKit

private let reuseIdentifier = "Cell"

class NearMeController: BaseViewController {
    @IBOutlet weak var tbl : UITableView!
    var residents : [Resident]?
    var locationManager: CLLocationManager!
    
    fileprivate let cellId = "NearMe"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.residents = GlobalData.nearMe
        self.tbl.reloadData()
        //self.collectionView!.reloadData()
     
    }

    // send information of 2 classmates you detected to server
    // if it sends successfully, you will take attendance successfully
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupData()
        self.residents = GlobalData.nearMe
        self.tbl.reloadData()
        //self.collectionView!.reloadData()
        
        navigationItem.title = "Near Residents"
        //for location
        
        // for Collection View
        
        tbl.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tbl.separatorColor = UIColor.seperatorApp
        tbl.tableFooterView = UIView.init(frame: CGRect.zero)
        
        NotificationCenter.default.addObserver(self,selector: #selector(load), name: NSNotification.Name(rawValue: "updateHistory"), object: nil)
//        let mapBtn = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NearMeController.maps(sender:)))
//        mapBtn.image = UIImage(named: "map")
//        self.navigationItem.rightBarButtonItem = mapBtn
        
    }
//    func maps(sender: UIBarButtonItem) {
//        // Perform your custom actions
//        // ...
//         self.performSegue(withIdentifier: "mapSegue", sender: nil)
//       
//    }
    
    
    func load(){
        self.residents = GlobalData.nearMe
        self.tbl.reloadData()
    }
    
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let count = residents?.count {
//            
//            return count
//            
//        }
//        return 1
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NearCell
//        if let resident = residents?[indexPath.item] {
//            cell.resident = resident
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
//     //   self.performSegue(withIdentifier: "detailSegue", sender: nil)
//        //    self.performSegue(withIdentifier: "detailSegue", sender: nil)
//        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        //        let controller = storyboard?.instantiateViewController(withIdentifier: "Detail") as! Detail
//        //                   self.navigationController?.pushViewController(controller, animated: true)
//        //                } else {
//        //                    NSLog("Nil cmnr")
//        //                }
//        
//    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        // retrieve selected cell & fruit
//        
//        if let indexPath = getIndexPathForSelectedCell() {
//            
//            let x = residents?[indexPath.item]
//            
//            let detailViewController = segue.destination as! Detail
//            detailViewController.resident = x!
//        }
//    }
//    
//    func getIndexPathForSelectedCell() -> IndexPath? {
//        
//        var indexPath:IndexPath?
//        
//        if (collectionView?.indexPathsForSelectedItems!.count)! > 0 {
//            indexPath = collectionView?.indexPathsForSelectedItems![0]
//        }
//        return indexPath
//    }
   
    
}
extension NearMeController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = residents?.count {
            return count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! NearMe
        cell.setData(resident: (self.residents?[indexPath.row])!)
        return cell
    }
}
