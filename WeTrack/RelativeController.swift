//
//  RelativeController.swift
//  WeTrack
//
//  Created by xuhelios on 2/22/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RelativeController: BaseViewController {
    
    @IBOutlet weak var tbl : UITableView!
    
    var relatives : [Resident]?
    
    fileprivate let cellId = "ResidentTableViewCell"
    
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
        tbl.estimatedRowHeight = 100
        tbl.rowHeight = UITableViewAutomaticDimension
        
        
        navigationItem.title = "Your relatives"
        
        
        
        self.relatives = GlobalData.relativeList
        
    }
    
    func reloadData() {
        
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
        cell.setData(resident: (relatives?[indexPath.row])!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue2", sender: nil)
        tbl.deselectRow(at: indexPath, animated: true)
    }
}
