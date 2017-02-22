//
//  RelativeController.swift
//  WeTrack
//
//  Created by xuhelios on 2/22/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RelativeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var relatives : [Resident]?
    
    fileprivate let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.relatives = GlobalData.relativeList
        self.collectionView!.reloadData()
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for Collection View
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        navigationItem.title = "Your relatives"
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(ResidentCell.self, forCellWithReuseIdentifier: cellId)
        
        self.relatives = GlobalData.relativeList
        
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = relatives?.count {
            
            return count
            
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ResidentCell
        if let relative = relatives?[indexPath.item] {
            cell.resident = relative
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
            
            let x = relatives?[indexPath.item]
            
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
